### 借助第三方工具 alipay

为了节约时间，这里我已经搭建好了一个小 demo，叫做 alipay-escrow-demo

    rails new alipay-escrow-demo -d mysql

这个 demo 的用途是售卖课程，首页上列出了所有的课程，有免费课程，也有收费课程。
点击一门收费课程，进入到课程的展示页面，看到一个大大的购买按钮，点击按钮就能通过支付宝付款了。

不过现在这个功能还没有实现，我们要借助 alipay 这个 gem 来完成。

alipay 这个 gem 提供的功能很齐全，不仅支持担保交易、还支持即时到账等多种支付宝服务。

在我们的演示实例中，只会用到担保交易收款接口和确认发货接口。那接下来就安装 alipay，在项目的 Gemfile
文件中添加如下一行，然后在命令行中运行 bundle 命令：

    gem 'alipay', '~> 0.7.1'

gem 安装之后，还需要添加这个 gem 的配置文件，根据文档，在 `config/initialize` 目录下，创建一个名为
alipay.rb 的文件，然后在文件中添加两行代码：

    Alipay.pid = 'YOUR_PID'
    Alipay.key = 'YOUR_KEY'

这个 gem 需要用到你从支付宝网站获得的 PID 和 Key，分别替换掉 YOUR_PID 和 YOUR_KEY，保存文件。

配置工作完成之后，就是使用这个 Gem 提供的接口了。但我们先要读一下文档
