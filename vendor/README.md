# vendor/ — 저장소에 사본으로 둔 외부 라이브러리

`.claude/skills/web-graphics-libs` 정책 P2에 따라 CDN 대신 저장소에 고정 사본을 둡니다. 모든 파일은 npm 레지스트리 tarball(`npm pack <pkg>@<ver>`)에서 수정 없이 복사했습니다.

| 패키지 | 버전 | 라이선스 | 사용처 |
|---|---|---|---|
| three | 0.186.1 (2026-09-24) | MIT | ship3d.html — 3D 장면, OrbitControls, Sky |
| cobe | 2.0.1 (2026-03-19) | MIT | ship3d.html — 항로 지구본 |
| canvas-confetti | 1.9.4 (2025-10-25) | ISC | ship3d.html — 입항 축하 효과 |

## 무결성 (sha384)

갱신하거나 검토할 때 `openssl dgst -sha384 -binary <file> | openssl base64 -A`로 다시 계산해 비교하세요.

```
vendor/canvas-confetti@1.9.4/confetti.module.mjs sha384-IjeHYzNs+oTl6WSRpwqIvkDRXsLg9Ao8IOfMyuBuYEVDR9aaFItXCe/oBT5z0NtR
vendor/cobe@2.0.1/index.esm.js sha384-rPeLIsPaCGXcrSCIX4lUqdfteCazOJRYIiUliZC+5v78XiDvfoE3b67Ib8onHipy
vendor/three@0.186.1/build/three.core.js sha384-mdKeCwPEcbDvzaxwhm+MVuLoMou+E7jQqrs4tmu/n8HBYPGI1kZt0MkJxlMR4zFM
vendor/three@0.186.1/build/three.module.js sha384-m8JoFX52V6NGv2usipnlLJKnJfL7IE8dbniPDDCSGSQv3Hm4n6PjfV6syVwfuoRc
vendor/three@0.186.1/examples/jsm/controls/OrbitControls.js sha384-LSqANrugPGTgf0eYsQTloqKWy926dOOXo2iZ9y6wLMIDEQoU9AaCLJF1Vcc7oJXr
vendor/three@0.186.1/examples/jsm/objects/Sky.js sha384-gHul8FeGcg6U8FJnOtoQ4uR+6i/NVtFv9BdPegZ/xdtEFE9vdowetkGWV6H69qQu
```
