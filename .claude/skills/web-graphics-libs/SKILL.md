---
name: web-graphics-libs
description: 이 저장소(index.html 단일 파일 UR E27/E26 심사 도구)에 3D·애니메이션·시각화·영상 효과를 넣을 때 사용. Three.js, drei, TWGL.js, Motion, Fabric.js, canvas-confetti, Rive Runtime, deck.gl, Cobe, ffmpeg.wasm 중 무엇을 쓸지 고르고, 외부 스크립트 도입 보안 정책(버전 고정·SRI·CDN 허용목록·데이터 외부 전송 금지)을 지키며 반영한다. "3D", "애니메이션", "폭죽", "지구본", "시각화", "영상 변환", 위 라이브러리 이름이 나오면 트리거.
---

# 웹 그래픽 라이브러리 도입 스킬

이 프로젝트는 **외부 의존성이 0인 단일 `index.html`** 입니다. 심사 데이터(선박·공급사 문서·체크리스트)는
`localStorage`(`iacstool-*`, `ur-e27-theme`, `rina-disc-dismissed`)에만 저장되고 네트워크로 나가지 않습니다.
라이브러리를 추가하는 순간 이 성질이 깨질 수 있으므로, 아래 정책을 **모든 변경에 먼저** 적용합니다.

> 참고: 아래 10개는 하나의 통합 패키지가 아니라 **서로 독립된 오픈소스**입니다. 라이선스·유지보수 상태를 각각 확인합니다.

## 1. 작업 순서

1. **필요성 판단** — CSS/SVG/Web Animations API로 될 일이면 라이브러리를 넣지 않는다 (기본값: 넣지 않음).
2. **라이브러리 선택** — `reference/libraries.md`의 표에서 용도·크기·제약을 확인해 *하나*만 고른다.
3. **정책 체크리스트(§2) 통과** 확인.
4. **지연 로딩**으로 구현 — 해당 기능을 사용자가 열 때만 `<script>`/`import()`를 삽입한다. 첫 화면 로딩에 영향 없게.
5. **실패 대비** — CDN 차단·오프라인에서도 심사 도구 본 기능은 그대로 동작해야 한다 (효과만 생략).
6. 검증(§4) 후 커밋.

## 2. 보안 정책 (필수)

| # | 규칙 |
|---|------|
| P1 | **버전 정확히 고정**: `three@0.x.y`처럼 정확한 버전. `@latest`, `@^1`, 범위 지정 금지. 공개된 지 **2주 이상** 지난 안정 버전만. |
| P2 | **SRI 필수**: 모든 외부 `<script>`/`<link>`에 `integrity="sha384-…"` + `crossorigin="anonymous"`. 해시는 `scripts/sri-hash.sh <URL>`로 직접 계산하며, 추측·기억으로 쓰지 않는다. 동적 `import()`는 SRI를 걸 수 없으므로 ESM이 필요한 경우 importmap의 `integrity` 필드를 쓰거나, 파일을 저장소에 벤더링(`vendor/<lib>@<ver>/`)한다. |
| P3 | **CDN 허용목록**: `cdn.jsdelivr.net/npm/`, `unpkg.com`, `cdnjs.cloudflare.com` 만. 그 외 도메인·개인 서버·단축 URL 금지. |
| P4 | **데이터 외부 전송 금지**: 심사 데이터·업로드 파일·`localStorage` 내용을 어떤 라이브러리/원격지로도 보내지 않는다. 텔레메트리·애널리틱스·원격 폰트/에셋 자동 로딩 기능은 끈다 (예: Rive의 wasm 경로, ffmpeg core 경로는 고정된 허용목록 URL로 명시). |
| P5 | **CSP 갱신**: 외부 스크립트를 추가하면 `<meta http-equiv="Content-Security-Policy">`의 `script-src`에 해당 CDN만 추가한다. `connect-src`는 wasm/코어 파일 로딩에 필요한 CDN으로 한정. `unsafe-eval`은 원칙적으로 금지 (ffmpeg.wasm 등 `wasm-unsafe-eval`이 필요한 경우만 해당 토큰 하나 허용). |
| P6 | **XSS 방지**: 사용자 입력(선박명, 코멘트, 업로드 파일명 등)을 라이브러리 텍스트/라벨/툴팁에 넣을 때 `textContent` 또는 이스케이프 후 사용. 기존 코드의 `innerHTML` 패턴을 새 사용자 입력에 확장하지 않는다. |
| P7 | **라이선스 확인**: MIT/Apache-2.0/BSD 계열인지 확인. ffmpeg.wasm 코어는 **LGPL/GPL**(빌드에 따라)이므로 도입 전 사용자 확인을 받는다. |
| P8 | **최소 도입**: 한 번에 라이브러리 하나. 같은 목적의 라이브러리 중복 금지 (예: Three.js와 TWGL.js 동시 도입 지양). |
| P9 | **브랜드/규제 표기 유지**: 효과가 RINA 브랜딩·면책(disclaimer)·심사 결과 표시를 가리거나 바꾸지 않는다. `prefers-reduced-motion: reduce`이면 애니메이션·폭죽은 끈다. |
| P10 | **사람 확인이 필요한 경우**: 새 외부 도메인 추가, 1 MB 이상 에셋, wasm 도입, 라이선스가 copyleft인 경우 → 구현 전에 사용자에게 묻는다. |

## 3. 표준 로더 패턴 (지연 로딩 + SRI)

```html
<script>
// 허용목록 CDN에서 SRI로 한 번만 로드. 실패 시 reject → 호출 측에서 효과 생략.
const ALLOWED_CDN = ['https://cdn.jsdelivr.net/npm/', 'https://unpkg.com/', 'https://cdnjs.cloudflare.com/'];
const _libCache = {};
function loadLib(src, integrity) {
  if (!ALLOWED_CDN.some(p => src.startsWith(p))) return Promise.reject(new Error('CDN not allowed: ' + src));
  if (!integrity) return Promise.reject(new Error('SRI required: ' + src));
  return _libCache[src] ||= new Promise((resolve, reject) => {
    const s = document.createElement('script');
    s.src = src; s.integrity = integrity; s.crossOrigin = 'anonymous';
    s.referrerPolicy = 'no-referrer'; s.async = true;
    s.onload = resolve; s.onerror = () => { delete _libCache[src]; reject(new Error('load failed: ' + src)); };
    document.head.appendChild(s);
  });
}
</script>
```

사용 예 (심사 완료 시 폭죽):

```js
async function celebrate() {
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  try {
    await loadLib('https://cdn.jsdelivr.net/npm/canvas-confetti@<VER>/dist/confetti.browser.min.js', 'sha384-<HASH>');
    window.confetti({ particleCount: 120, spread: 70, disableForReducedMotion: true });
  } catch (_) { /* 효과 생략, 기능은 계속 */ }
}
```

`<VER>`/`<HASH>`는 반드시 실제 값으로 채운다: `bash .claude/skills/web-graphics-libs/scripts/sri-hash.sh <URL>`.

## 4. 검증 체크리스트 (커밋 전)

- [ ] 모든 외부 URL이 허용목록 CDN + 정확한 버전 + `integrity` 보유 (`grep -nE 'src="https?://' index.html`)
- [ ] 네트워크 차단 상태에서 페이지를 열어도 체크리스트·저장·내보내기 기능 정상
- [ ] DevTools Network에 허용목록 외 요청, `localStorage` 데이터가 실린 요청 없음
- [ ] 라이트/다크 테마 모두에서 효과 색이 CSS 변수(`--blue`, `--rina-navy` 등)를 따름
- [ ] `prefers-reduced-motion`에서 애니메이션 꺼짐
- [ ] 모바일 폭(360px)에서 가로 스크롤 없음, 캔버스는 `devicePixelRatio` 반영 후 리사이즈 처리
- [ ] 커밋 메시지에 도입 라이브러리·버전·용도·SRI 계산 방법 기록

라이브러리별 용도·제약·주의점은 `reference/libraries.md`를 본다.
