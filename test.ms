filein "oop.ms"

struct A
(
    public 
        num2 = 2,
        fn getsum = this.num + this.num2,
        fn testfun = print "结构体A的测试函数打印",
    private
        num = 34
)

struct B
(
    public
        str = "测试字符串",
        fn getsum = 
        ( 
            this.super.testfun()
		    suthis.superper.getsum() 
        ),
        fn getTestStr = this.teststr,
        fn oncreate = 
        (
            print "结构体B正在创建实例"
        ),
        fn onclone =
        (
            print "结构体B正在克隆实例"
        ),
    private
        teststr = "私有的测试字符串"
)
--oop.SetSuperClass subclass:this super:A


a = A()
a.getsum()

b = B()
b.str
oop.BuildAllSourceFile "F:\\ksword.zhang\\CloudProductionProject\\maxscript" 