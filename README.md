# OBJC-Todo

Objective-C 실습을 위한 앱 개발입니다.

## 구현 목표

* 이벤트 기반 애플리케이션을 만듭니다.
* 저장소를 만들기보다는 메모리에 저장하더라도 정확한 입력창과 리스트를 만듭니다.
* 꼭 사용해야 하는 뷰 클래스는 다음과 같습니다. 
  - UITableView
  - UICollectionView
  - UITextField
  - UITextView
  - UIButton
* 아키텍처는 클린 아키텍처의 양파 그림을 토대로 진행해 봅니다.

![CleanArchitecture](OBJC-Todo/Resources/Assets.xcassets/CleanArchitecture.imageset/CleanArchitecture.jpg)

* 뷰 모델을 작성하고 유닛 테스트를 작성합니다.
  - 뷰 모델의 Reactivity 를 위해 [ReactiveObjC](https://github.com/ReactiveCocoa/ReactiveObjC) 를 설치합니다.