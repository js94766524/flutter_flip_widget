# Flip

翻转效果控件, 可以水平或垂直翻转控件。

```dart
  Widget build(BuildContext context){
    return Flip(
      controller:controller,                      //FlipController实例，用来控制翻转动作
      flipDirection: Axis.horizontal,             //或Axis.vertical，水平翻转或垂直翻转
      flipDuration: Duration(milliseconds: 200),  //翻转动画时间，默认值为300毫秒
      firstChild: Container(),                    //正面的控件
      secondChild: Container(),                   //背面的控件
    );
  }
  
  void onAnyAction(){
    controller.isFront = true;  //翻转到正面
    controller.isFront = false; //翻转到背面
    controller.flip();          //翻转到相反面
  }
```
