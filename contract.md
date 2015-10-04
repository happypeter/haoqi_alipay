---
layout: book
title: 签约支付宝
---

视频：02_contract_doc.mov

### 内容简介

和支付宝签订担保交易收款合同，得到 pid 和 key 。下载开发文档。

### 签约过程

可以到 <a href="http://b.alipay.com">b.alipay.com</a> 点击“产品商店”，选择“产品大全”，看到”担保交易收款“，点进入。国内的网站都是要备案的，用不用支付宝都一样。但是如果你的服务器在国外，网站也没有备案，那么也一样是可以使用支付宝的。比如我自己的 <a href="http://haoqicat.com">haoqicat.com</a> 就是这种情况，而且用支付宝接口收款两年多了，没有任何问题。

提交申请之后，差不多要等待三个工作日，才能知道审核结果。一次签约的期限大概是一年吧，到期之后，支付宝公司的服务还是很贴心的，不断给你发短信，邮件，不断提醒你续签合同，续签是很简单的，而且也不收钱。

### 下载文档

进行解压缩。
在 ubuntu 中使用 unzip 来进行解压缩

{% highlight console %}
unzip -O GBK alipayescow.zip
{% endhighlight %}

上面 `-O` 后面添加编码格式是必须的，不然解压出来的文件名就都是乱码。解压后由个别文件中的中文内容是乱码，可以用下面的命令来转换编码格式。

{% highlight console %}
iconv -f GBK -t UTF-8 -o output.txt 更新日志.txt
{% endhighlight %}

### 其他参考资源

提一下，支付宝官方有一个 <a href="http://fun.alipay.com/zfbxt/qianyueditu.htm?src=nsf04">签约地图</a> 的页面，挺好看，不过内容暂时还比较空。
