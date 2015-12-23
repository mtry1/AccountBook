# AccountBook

主要结构（View <-> ViewController <-> DataManager <-> Model）
View：主要负责试图的显示
ViewController：控制试图，以及监听DataManager的数据变化
DataManager：处理全部的业务逻辑
Model：简单的数据存储
注：ViewController <-> DataManager通过代理通信，主要目的限制跨层通信
