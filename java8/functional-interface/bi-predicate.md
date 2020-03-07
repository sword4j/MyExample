# Java 8 BiPredicate的使用方法及实例
在Java8中[BiPredicate](https://docs.oracle.com/javase/8/docs/api/java/util/function/BiPredicate.html)是一个函数式接口，它可以接受两个参数然后返回一个布尔值。`BiPredicate`与[Predicate](predicate.md)有点相似，但`Predicate`只能接受一个参数。

**BiPredicate.java**

```java
@FunctionalInterface
public interface BiPredicate<T, U> {
    boolean test(T t, U u);
}
```

进一步阅读：[Java 8 Predicate的使用方法及实例](predicate.md)

## 实例1：检测字符串的长度与指定的长度是否相等

**JavaBiPredicate1.java**

```java
package cc.myexample.java8;

import java.util.function.BiPredicate;

public class JavaBiPredicate1 {

    public static void main(String[] args) {

        BiPredicate<String, Integer> filter = (x, y) -> {
            return x.length() == y;
        };

        boolean result = filter.test("myexample", 9);
        System.out.println(result);  // true

        boolean result2 = filter.test("java", 10);
        System.out.println(result2); // false
    }

}
````

**输出**
```
true
false
```

## 实例2：使用名称和评分过滤出域名

```java
package cc.myexample.java8;

import java.util.Arrays;
import java.util.List;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

public class JavaBiPredicate2 {

    public static void main(String[] args) {

        List<Domain> domains = Arrays.asList(new Domain("google.com", 1),
                new Domain("i-am-spammer.com", 10),
                new Domain("myexample.cc", 0),
                new Domain("microsoft.com", 2));

        BiPredicate<String, Integer> bi = (domain, score) -> {
            return (domain.equalsIgnoreCase("google.com") || score == 0);
        };

        // 过滤出google.com或评分等于0的域名
        List<Domain> result = filterBadDomain(domains, bi);
        System.out.println(result); // google.com, myexample.cc

        //  过滤出所以评分等于0的域名
        List<Domain> result2 = filterBadDomain(domains, (domain, score) -> score == 0);
        System.out.println(result2); // myexample.cc, microsoft.com

        // 过滤出以i开始且评分大于5的域名
        List<Domain> result3 = filterBadDomain(domains, (domain, score) -> domain.startsWith("i") && score > 5);
        System.out.println(result3); // i-am-spammer.com

        // 使用or进行串联，过滤出google.com或域名评分等于0的或micorsoft.com
        List<Domain> result4 = filterBadDomain(domains, bi.or(
                (domain, x) -> domain.equalsIgnoreCase("microsoft.com"))
        );
        System.out.println(result4); // google.com, myexample.cc, microsoft.com


    }

    public static <T extends Domain> List<T> filterBadDomain(
            List<T> list, BiPredicate<String, Integer> biPredicate) {

        return list.stream()
                .filter(x -> biPredicate.test(x.getName(), x.getScore()))
                .collect(Collectors.toList());

    }
}

class Domain {

    String name;
    Integer score;

    public Domain(String name, Integer score) {
        this.name = name;
        this.score = score;
    }
    // 省略 getters、setters、toString
}
```

**输出**

```
[Domain{name='google.com', score=1}, Domain{name='myexample.cc', score=0}]
[Domain{name='myexample.cc', score=0}]
[Domain{name='i-am-spammer.com', score=10}]
[Domain{name='google.com', score=1}, Domain{name='myexample.cc', score=0}, Domain{name='microsoft.com', score=2}]
```
