# SOLID原则的概念和理解
--- 
*希望若干年后的我看到这篇文章的时候会觉得这是一篇入门文章而不再是遗憾的知识盲点。*

S·O·L·I·D原则是面向对象编程的五大原则的缩写

| 简称 | 全称 | 描述 |
| --- | --- | --- |
| SRP | Signal Responsibility Priciple | 单一责任原则 |
| OCP | Open Close Priciple | 开放关闭原则 |
| LSP | Liskov Substitution Priciple | 里式替换原则 |
| ISP | Interface Segregation Priciple | 接口分离原则 |
| DIP | Dependency Invertion Priciple | 依赖倒置原则 |



### SRP

> a class should have only a single responsibility (i.e. changes to only one part of the software's specification(规范) should be able to affect the specification of the class).
> 
> 规定每个类都应该有一个单一的功能，并且该功能应该由这个类完全封装起来。所有它的（这个类的）服务都应该严密的和该功能平行（功能平行，意味着没有依赖）

单一职责原则，一个类只一项职责,具体的例子在YSDQ代码中，会看到BZXVideoForDownload本身是一个模型类，但是他不但做了模型类，而且还做了开始下载、删除下载、存储文件路径等任务，已经超出一个模型类的职责。

    评价：很好理解但是很多都容易忽略的原则，代码中经常会违反这个原则。


### OCP
> software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification

> 软件中的对象（类，模块，函数等等）应该对于扩展是开放的，但是对于修改是封闭的

这意味着一个实体是允许在不改变它的源代码的前提下变更它的行为；结合实际开发中的在保证已经上线的功能功能不受影响的情况下，不去修改已有的代码，而是对已有的实体进行扩展。例如之前在弹出框问题的修改上，

    评价:iOS中API中的类的设计很好的坚持了这个原则，并且提供了系统类的扩展形式extension、category。
    实际开发过程中的代码并没有注意到这个原则。
    
### LDP
>  if S is a subtype of T, then objects of type T may be replaced with objects of type S (i.e. an object of type T may be substituted with any object of a subtype S) without altering any of the desirable properties of the program (correctness, task performed, etc.).
> 
> 里氏替换原则的内容可以描述为： “派生类（子类）对象能够替换其基类（超类）对象被使用。”

在[某博客](https://blog.csdn.net/gaomengwang/article/details/54598435)中，作者应用了一个长方形和正方形的例子，不过还是没看明白，后续继续研究。

```
public class Rectangle {
    private double width;
    private double height;

     public void setWidth(double value) {
         this.width = value;
     }

     public double getWidth() {
         return this.width;
     }

     public void setHeight(double value) {
         this.width = value;
     }

     public double getHeight() {
         return this.height;
     }

     public double Area() {
         return this.width*this.height;
     }
}

public class Square extends Rectangle {

    /* 由于父类Rectangle在设计时没有考虑将来会被Square继承，所以父类中字段width和height都被设成private，在子类Square中就只能调用父类的属性来set/get，具体省略 */
}

// 测试
void TestRectangle(Rectangle r) {
    r.Weight=10;
    r.Height=20;
    Assert.AreEqual(10,r.Weight);
    Assert.AreEqual(200,r.Area);
}

// 运行良好
Rectangle r = new Rectangle ();
TestRectangle(r);

// 现在两个Assert测试都失败了
Square s = new Square();
TestRectangle(s);
```

### ISP 
> The interface-segregation principle (ISP) states that no client should be forced to depend on methods it does not use.[1] ISP splits interfaces that are very large into smaller and more specific ones so that clients will only have to know about the methods that are of interest to them. 
> 
> 指明客户（client）应该不依赖于它不使用的方法。[1]接口隔离原则(ISP)拆分非常庞大臃肿的接口成为更小的和更具体的接口，这样客户将会只需要知道他们感兴趣的方法。

这个也好理解，实际项目中很多由于懒惰或者没有意识，这样的问题依然存在，比如某两个类的代理方法，恨不得把所有这两个类可能通信的接口都写在这。

    评价：要先意识到这个原则再去反观代码
    
### DIP
> In object-oriented design, the dependency inversion principle refers to a specific form of decoupling software modules. When following this principle, the conventional dependency relationships established from high-level, policy-setting modules to low-level, dependency modules are reversed, thus rendering high-level modules independent of the low-level module implementation details. The principle states:[1]
> 
A. High-level modules should not depend on low-level modules. Both should depend on abstractions.
B. Abstractions should not depend on details. Details should depend on abstractions.
>
> A. 高层模块不应该依赖于低层模块，二者都应该依赖于抽象 
> B. 抽象不应该依赖于细节，细节应该依赖于抽象
>
>  (1).高层模块不要依赖低层模块；
>(2).高层和低层模块都要依赖于抽象；
>(3).抽象不要依赖于具体实现； 
>(4).具体实现要依赖于抽象；
>(5).抽象和接口使模块之间的依赖分离。

    评价：在实际应用过程中ViewModel的存在印证了这个原则，
    让数据层和UI层隔离开，都依赖ViewModel这个抽象的接口，
    从而达到分层的目的，以及分层测试的好处
    
实际测试过程中，如果网络接口有修改，对应需要修改的是接受端的数据模型层，而从数据模型层到Viewmodel的映射需要重新测试，
但viewModel层到UI层则不需要重新测试。


