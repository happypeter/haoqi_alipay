---
layout: book
title: 搭建网站基本框架
---

视频：03_app_setup.mov

### 内容简介

搭建 Rails 项目，添加 alipay 这个 Gem ，填写 PID/KEY 。

### 搭建 Rails 项目

这一集里面就是把 alipay 这个 Gem 添加进来，并且把 PID/KEY 添加到 alipay.rb 文件里面，如果你对 rails 项目搭建非常熟悉了，基本上直接可以跳到视频的最后几分钟进行观看。

支付宝官方教程在 <a href="http://fun.alipay.com/zfbxt/">这里</a>，例如可以查看 <a href="http://fun.alipay.com/zfbxt/jicheng.html#pidkey">什么是 PID/KEY ？</a>

### 底层数据填充

搭建步骤如下。首先创建一个新的 rails 项目，我使用的 rails 版本是 4.1.6 。

{% highlight console %}
rails -v
rails new haoqi_alipay -d mysql
cd alipay
rake db:create db:migrate # 由于我本地 mysql 没有设置密码，所以也不用修改 database.yml 文件
rails s
{% endhighlight %}

这样就可以用 `local.dev:3000` 来访问项目了

添加下面的内容到 `application.rb` 中添加下面的内容，目的是在运行 rails generator 的时候不会生成很多辅助性的文件

{% highlight ruby %}
config.generators do |g|
  g.assets false
  g.helper false
  g.test_framework false
end
{% endhighlight %}

来生成 `cups` 表

{% highlight console %}
rails g model cup name:string price:float cover:string
rake db:migrate
{% endhighlight %}

然后用 `seeds.rb` 来填充数据

{% highlight ruby %}
Cup.create([{ name: '白色杯子', price: '4.5', cover: 'white.jpg'}, { name: '绿色杯子', price: '7.5', cover: 'green.jpg'}])
{% endhighlight %}

数据库中填充两个杯子的数据

{% highlight console %}
rake db:seed
{% endhighlight %}

下面，把 `white.jpg` 和 `green.jpg` 两张杯子的图片，放到 `app/assets/images` 中备用。

### 页面展示

下一步来在首页上显示出这两个杯子

{% highlight console %}
rails g controller cups index
{% endhighlight %}

修改 `routes.rb`

{% highlight ruby %}
--- get 'cups/index'
+++ root 'cups#index'
{% endhighlight %}


修改 `cups_controller.rb` 中的 `index` 方法

{% highlight ruby %}
def index
  @cups = Cup.all
end
{% endhighlight %}

下面从源码仓库中拷贝 `views/cups/index.html` 和 `app/assets/stylesheets/main.scss` 。

然后修改 `application.html.erb` 文件，如下

{% highlight erb %}
<header>
  <%= yield :head %>
</header>
<div class="wrapper">
  <%= yield %>
</div>
{% endhighlight %}

`rails s` 这时候就可以看到首页上的两个杯子了 。

下面就需要创建 orders 表，但是 orders 表中的各个字段名其实是根支付宝返回的字段名相关的，所以这一集先不弄了 。


### 添加 gem ，填写 PID/KEY

参考 <https://github.com/chloerei/alipay> 的 README 的说明，到 `Gemfile` 中添加

{% highlight ruby %}
gem 'alipay', '~> 0.7.1' # 版本号随着日期改变可能发生变化
{% endhighlight %}

然后运行 `bundle` 命令来安装。顺便提一下，最近两天 rubygems.org 有点被墙，不翻墙的话安装 gem 会报出 SSL 错误。

到支付宝网站上拿到 PID 和 KEY，然后创建一个 `config/initializers/alipay.rb` 里面填入

{% highlight ruby %}
Alipay.pid = 'YOUR_PID'
Alipay.key = 'YOUR_KEY'
{% endhighlight %}

这个文件中包含机密信息，如果你跟我一样用 git 做版本控制，要把文件名填写到 `.gitignore` 文件中，可以创建一个 `alipay.rb.example` 文件作为备忘，commit 到源码中。

好，这一集就到这里了。
