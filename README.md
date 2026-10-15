# Fast Book Reading

A standalone **Don't Starve Together** mod that speeds up book reading. Default: **3×**; choose **2×**, **3×**, or **5×** in the mod settings. The reading animation, its timed sounds, and the moment the book's effect occurs are accelerated together.

The mod keeps DST's original `READ` action and book effect callbacks. It changes only real book reads handled by the `book` and `book2` player states. Spellbook casts and other actions that share those states retain their normal timing. Cookbook and other simple books, Wurt's peruse animation, and unrelated actions are unchanged.

## Install locally

1. Copy this repository folder into `Don't Starve Together/mods/fast-book-reading`.
2. Enable **Fast Book Reading** in the game's Mods menu for your world.
3. Pick a reading speed in the mod configuration. In multiplayer, all clients need the mod.

## Development and compatibility

The mod hooks the existing `wilson` and `wilson_client` stategraphs. It wraps the vanilla state callbacks and keeps the original timeline callbacks, using earlier times only for `READ`. It does not replace `ACTIONS.READ` or the book component. Mods that replace those player states or change the player's animation speed during the same read may still conflict.

Checked against the installed DST game scripts, build **756039**. An in-game multiplayer test is still needed before a Workshop release. See [Workshop text](WORKSHOP_DESCRIPTION.md) for the future listing. No Steam Workshop item has been published.

License: MIT.

---

# 빠른 책 읽기

**돈 스타브 투게더**에서 책 읽는 속도를 높이는 단독 모드입니다. 기본값은 **3배**이며 모드 설정에서 **2배**, **3배**, **5배**를 선택할 수 있습니다. 책 읽기 애니메이션, 관련 효과음, 실제 책 효과가 발동하는 시점을 함께 앞당깁니다.

게임의 기본 `READ` 행동과 책 효과 처리 함수는 그대로 사용합니다. 실제 책 읽기에 사용하는 플레이어 상태 `book`, `book2`에만 적용됩니다. 같은 상태를 사용하는 주문책 시전은 원래 속도를 유지합니다. 요리책 등 단순 책, 워트의 훑어보기 동작, 다른 행동도 바꾸지 않습니다.

## 로컬 설치

1. 이 저장소 폴더를 `Don't Starve Together/mods/fast-book-reading`으로 복사합니다.
2. 게임의 모드 메뉴에서 **Fast Book Reading**을 활성화합니다.
3. 모드 설정에서 속도를 선택합니다. 멀티플레이에서는 모든 플레이어가 모드를 설치해야 합니다.

## 개발 및 호환성

기본 `wilson`, `wilson_client` 상태 그래프를 확장합니다. 기존 상태 함수와 타임라인 함수를 유지하면서 실제 `READ` 동작의 실행 시간만 줄입니다. `ACTIONS.READ`나 책 컴포넌트를 교체하지 않습니다. 같은 플레이어 상태를 교체하거나 책 읽는 동안 캐릭터 애니메이션 속도를 바꾸는 다른 모드와는 충돌할 수 있습니다.

설치된 DST 게임 스크립트 **빌드 756039**와 대조했습니다. 창작마당 등록 전 게임 내 멀티플레이 테스트가 필요합니다. 향후 등록용 문구는 [창작마당 설명](WORKSHOP_DESCRIPTION.md)에 있습니다. 아직 Steam 창작마당에는 등록하지 않았습니다.

라이선스: MIT.
