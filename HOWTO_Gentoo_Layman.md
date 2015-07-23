# 소개 #

nilay svn을 Gentoo Layman 에 추가시켜 사용하는 방법을 설명하겠습니다.

## 변경사항 ##
1. layman xml 설정파일을 이 프로젝트의 'Downloads'섹션에 올렸습니다.

2. 새로 바뀐 트리구조에 맞게 문서를 수정하였습니다.


# 들어가기전에... #

Nilay는 아시다시피 Official Tree가 아닙니다. 가능한한 EAPI 준수, RDEPEND/BDEPEND 구분, 빠른 수정 들을 지키려고 노력은 하지만 때론 이빌드 자체의 결함이나 패키지 자체의 결함이 있을 수 있습니다.

이에 대한 물리적 피해나 데이터 손실은 책임지지 않습니다.

일부 패키지들은 개발 중인 저장소에서 바로 가져오지만, 키워드를 통해 셋업을 막지 않은 경우가 있습니다. 이런 패키지를 사용하실때는 주의해주시기 바랍니다.

# Overlay 설정 #

1. **Overlay를 설정 하고 체크아웃 하기 위해서는 layman을 설치해야합니다.**
|# emerge layman|
|:--------------|

2. **이제 layman.cfg를 수정합니다.**
|# nano /etc/layman/layman.cfg|
|:----------------------------|

3. **아래와 같은 부분을 찾아서**
|overlays  : http://www.gentoo.org/proj/en/overlays/layman-global.txt|
|:-------------------------------------------------------------------|

**다음과 같이 수정합니다.**
```
overlays  : http://www.gentoo.org/proj/en/overlays/layman-global.txt
            http://nilay.googlecode.com/files/nilay.xml
```

4. **layman.cfg내에서 nocheck 부분을 찾아서 아래와 같이 바꿉니다.**
|nocheck : yes|
|:------------|

5. **layman Overlay 리스트를 갱신합니다.**
|# layman -f|
|:----------|

6. **layman Overlay 리스트를 확인합니다.**
|# layman -L|grep nilay|
|:---------------------|

**아래의 오버레이가 나온다면 설정이 완료된 것입니다.
```
* nilay-dfb                 [Subversion] (http://nilay.googlecode.com/svn/tr...)
* nilay-e17                 [Subversion] (http://nilay.googlecode.com/svn/tr...)
* nilay-main                [Subversion] (http://nilay.googlecode.com/svn/tr...)
```**

7. **이제 nilay Overlay에서 필요한 것들을 추가합니다.**

|# layman -a nilay-main|
|:---------------------|

이제  Nilay를 사용하실 수 있습니다. 각 저장소별로 특징이 있으니 몽땅 layman -a 를 하는 것 보다는 자신에게 필요한 것만 추가하는 걸 추천합니다.

**수고 많으셨습니다 :)**


**조언 : 때론, 이곳의 'Sources'탭을 누르셔서 변경 사항을 확인해 보신후 트리를 업데이트하시기 바랍니다.**|# layman -S| <-모든 Overlay가 업데이트 |
|:----------|:-------------------|
|# layman -s nilay-(main|e17|dfb)| <- nilay Overlay중 일부만 업데이트|