+++
title = "python classmethod 和 staticmethod"
author = ["Li Xunsong"]
date = 2021-09-19
lastmod = 2021-09-19T17:34:46+08:00
draft = false
+++

## Intro {#intro}

在 `stackoverflow` 上看到讲解 `staticmethod` 和 `classmethod` 之间区别的[回答](https://stackoverflow.com/questions/12179271/meaning-of-classmethod-and-staticmethod-for-beginner)，翻译整理一下。

对于 `classmethod` 修饰的函数，必须接收一个 `class object` 作为第一个参数，而 `staticmethod` 可以不带参数。用一个具体的例子说明二者之间的区别：

```python
class Date(object):
    def __init__(self, day=0, month=0, year=0):
	self.day = day
	self.month = month
	self.year = year

    @classmethod
    def from_string(cls, date_as_string):
	day, month, year = map(int, date_as_string.split('-'))
	date1 = cls(day, month, year)
	return date1

    @staticmethod
    def is_date_valid(date_as_string):
	day, month, year = map(int, date_as_string.split('-'))
	return day <= 31 and month <= 12 and year <= 3999

    def display(self):
	return "{0}-{1}-{2}".format(self.month, self.day, self.year)

# 通过类名来调用
date2 = Date.from_string('11-09-2012')
is_date = Date.is_date_valid('11-09-2012')

# 通过类实例来调用
print(date2.is_date_valid('11-09-2012'))
date3 = date2.from_string('10-09-2012')
print(date3.display())
```

在这个例子中，`from_string` 是一个 `classmethod`, 它的作用是，按指定格式的字符串来初始化一个 `Date` 对象。在 `Date` 的 `__init__` 函数中定义了初始化一个 `Date` 对象所需要的参数，如果这里我们想通过给出一个字符串来初始化得到一个 `Date` 对象，我们首先需要将这个字符串解析出 `day`, `month`, `year` 的内容，然后将这些内容传入 `Date` 的 `__init__` 来初始化得到 `Date` 对象：

```python
day, month, year = map(int, string_date.split('-'))
date1 = Date(day, month, year)
```

在 `C++` 中，可以通过重载构造函数的方式，来实现这个目的。而在 `python` 里面，没有提供重载构造函数的功能，因此需要借助 `classmethod`, 来实现这一 feature. 在上面的例子中，`Date.from_string` 返回的也是一个 `Date` 对象。这就相当于我们有了两种创建一个 `Date` 对象的手段，一是直接使用 `Date()`, 这将调用 `__init__` 函数，二是显式地通过 `Date.from_string`, 它从格式化的字符串中创建一个 `Date` 对象。

而这里的 `is_date_valid` 函数是一个 `staticmethod`, 它用于检查构造日期的字符串是否合法，它的参数中，不包含 class object 或者 instance object. 它和一个普通的函数并没有太多区别，只是为这个类提供了一些 `helper function`.

无论是 `staticmethod` 还是 `classmethod`, 子类都可以继承。

在使用 `staticmethod` 或 `classmethod` 的时候，都可以通过类名或者实例来调用。
