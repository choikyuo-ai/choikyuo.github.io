# choikyuo.github.io

GitHub Pages로 배포되는 **IACS UR E27/E26 사이버 복원력 심사 도구** (단일 파일 `index.html`, 외부 의존성 없음).

## 원칙
- 모든 코드·스타일은 `index.html` 안에 인라인. 빌드 단계 없음.
- 심사 데이터는 `localStorage`(`iacstool-*` 키)에만 저장하며 **어떤 외부로도 전송하지 않는다**.
- 테마는 `:root`의 CSS 변수와 `[data-theme]`로 관리 — 새 UI도 이 변수를 사용.
- 사용자 입력을 `innerHTML`에 넣지 말 것 (`textContent` 또는 이스케이프).

## 외부 라이브러리 (3D·애니메이션·시각화·영상)
Three.js, drei, TWGL.js, Motion, Fabric.js, canvas-confetti, Rive, deck.gl, Cobe, ffmpeg.wasm 등을 쓰려면
**반드시 `.claude/skills/web-graphics-libs/SKILL.md`의 보안 정책을 따른다** — 정확한 버전 고정, SRI 필수,
CDN 허용목록(jsdelivr/unpkg/cdnjs), 지연 로딩, 오프라인에서도 본 기능 동작, 데이터 외부 전송 금지.
새 외부 도메인·wasm·1 MB 이상 에셋·copyleft 라이선스는 구현 전에 사용자 확인.
