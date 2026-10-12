# 라이브러리별 가이드

각 라이브러리는 **독립 오픈소스**입니다. 도입 시 npm 페이지에서 최신 안정 버전·배포일·라이선스를 직접 확인하고 SKILL.md §2 정책을 적용하세요.

| 분류 | 라이브러리 | 용도 | 이 프로젝트 적합도 | 주의점 |
|------|-----------|------|------------------|--------|
| 🎨 3D | **Three.js** (`three`) — github.com/mrdoob/three.js | 입체 공간·3D 장면 (선박/네트워크 구성도 3D 뷰 등) | ○ 필요 시 | r150+부터 ESM 중심. `<script type="importmap">`에 `integrity` 지정 또는 `vendor/`에 벤더링. 애드온(`three/addons/...`)도 같은 버전으로 고정. MIT. |
| 🎨 3D | **drei** (`@react-three/drei`) | 3D 카메라·조명 도우미 | ✕ 비권장 | **React + react-three-fiber 전용**. 이 프로젝트는 바닐라 JS 단일 HTML이므로 React 도입 없이 사용 불가. 대신 Three.js의 `OrbitControls`, `HemisphereLight` 등 애드온 사용. |
| 🎨 3D | **TWGL.js** (`twgl.js`) | WebGL 저수준 헬퍼 | △ | 셰이더를 직접 다룰 때만. Three.js와 중복 도입 금지. GLSL 문자열에 사용자 입력을 넣지 않는다. MIT. |
| ✨ 애니메이션 | **Motion** (`motion`) | 부드러운 화면 전환 | ○ | 바닐라 `animate()` API 사용(React 버전 아님). 단순 전환은 CSS transition/Web Animations API로 충분한지 먼저 검토. MIT. |
| ✨ 애니메이션 | **Fabric.js** (`fabric`) | 2D 캔버스 편집 (도면 주석, 구역 표시 등) | △ | `loadFromJSON`/`loadSVGFromString`에 **외부·사용자 제공 데이터를 그대로 넣지 말 것**(SVG 내 스크립트·외부 참조). 객체 텍스트는 일반 문자열로만. MIT. |
| ✨ 애니메이션 | **canvas-confetti** | 폭죽·파티클 효과 (심사 완료 축하 등) | ○ 가장 가벼움 | `disableForReducedMotion: true`. 심사 결과(Fail/Not met) 화면에는 쓰지 않는다. ISC. |
| ✨ 애니메이션 | **Rive Runtime** (`@rive-app/canvas`) | 상태 기반 반응형 애니메이션 | △ | `.riv` 에셋과 **wasm을 기본적으로 unpkg에서 자동 다운로드** → `RuntimeLoader.setWasmUrl()`로 고정 버전 URL(허용목록) 지정, CSP `connect-src` 반영. `.riv` 파일은 저장소에 두고 출처 확인. MIT. |
| 🌍 시각화 | **deck.gl** (`deck.gl`) | 대규모 데이터 시각화 (선단 위치, 자산 맵) | △ 무거움 | 번들이 크다(수 MB) → P10 사용자 확인. 지도 타일·basemap 서비스(Mapbox 등)는 **API 키·외부 전송**이 생기므로 기본 금지, 필요 시 별도 승인. MIT. |
| 🌍 시각화 | **Cobe** (`cobe`) | 인터랙티브 3D 지구본 (선박 위치 표시 등) | ○ 가벼움(~5 KB) | 마커 좌표는 민감할 수 있음(선박 위치) → 화면 표시만, 외부 전송 없음. `devicePixelRatio`·리사이즈·`destroy()` 처리. MIT. |
| 🌍 영상 | **ffmpeg.wasm** (`@ffmpeg/ffmpeg`, `@ffmpeg/core`) | 브라우저 내 영상 변환 | ✕ 기본 금지 | 코어 ~30 MB, 멀티스레드는 `SharedArrayBuffer` → **COOP/COEP 헤더 필요한데 GitHub Pages에서는 설정 불가**(싱글스레드 core만 가능). `wasm-unsafe-eval` 필요. 코어 라이선스 LGPL/GPL. 도입 시 반드시 사용자 승인(P7, P10). 사용자가 올린 파일은 로컬에서만 처리. |

## 선택 가이드

- 축하·피드백 효과 → **canvas-confetti**
- 패널/탭 전환 → CSS 우선, 부족하면 **Motion**
- 지구본에 선박 위치 → **Cobe** (대량 데이터·지도 필요 시에만 deck.gl)
- 3D 구성도·장면 → **Three.js** (drei 대신 Three.js 애드온)
- 커스텀 셰이더 → **TWGL.js** (Three.js와 택1)
- 도면 위 주석/편집 → **Fabric.js**
- 디자이너가 만든 인터랙티브 애니메이션 → **Rive**
- 영상 변환 → 원칙적으로 도입하지 않음 (서버·로컬 도구 권장)

## 요청 예시 (Claude Code에 이렇게 요청)

- "심사 체크리스트를 모두 Met으로 완료하면 canvas-confetti로 폭죽 효과를 넣어줘. web-graphics-libs 정책대로."
- "Vessel 탭에 Cobe 지구본을 넣고 입력한 선박 위치에 마커를 표시해줘. 외부 전송 없이."
- "Zone/Conduit 구성도를 Three.js로 3D 뷰를 추가해줘. 버튼 눌렀을 때만 로드."
