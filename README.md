## UI效果仿照前端element-UI的[Tree控件](https://element.eleme.cn/#/zh-CN/component/tree)
# **视图层**
### 正常树形显示

这里显示十级  每级100条数据 总共1000条数据的效果图

![treeNone.gif](https://upload-images.jianshu.io/upload_images/9163368-4c0890c33838370a.gif?imageMogr2/auto-orient/strip)

```
WMZTreeViewParam *param =TreeViewParam() .wDataSet(@[TreeParam(),TreeParam()])
self.treeView = [[WMZTreeView alloc]initWithParam:param];
[self.view addSubview:self.treeView];
```

### 可选中树形+选中高亮显示

![treeSelect.gif](https://upload-images.jianshu.io/upload_images/9163368-22a48815e35c5df9.gif?imageMogr2/auto-orient/strip)

```
TreeViewParam()
 //可勾选
.wShowCheckboxSet(YES)
 //节点字体高亮颜色
.wHighlightCurrentSet(TreeColor(0x1d76db))
```

### 自定义节点内容+增删节点

![treeCell.gif](https://upload-images.jianshu.io/upload_images/9163368-c2b322014e6d2121.gif?imageMogr2/auto-orient/strip)


```
TreeViewParam()
 //自定义节点内容
.wEventTreeCellSet(^UITableViewCell *(id model, NSIndexPath *path,UITableView *table,id param) {
      WMZMyCell *cell = [table dequeueReusableCellWithIdentifier:@"WMZMyCell"];
       if (!cell) {
          cell = [[WMZMyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMZMyCell" parentModel:param];
        }
      cell.model = model;
      return cell;
 })

增删实例方法

/*
 *为 Tree 中的一个节点追加一个子节点
  @param currrentID 当前节点
  @param param 子节点数据
  @return BOOL 是否追加成功
 */
- (BOOL)append:(NSString*)currrentID node:(WMZTreeParam*)param;

/*
 *为 Tree 的一个节点的后面增加一个节点
  @param currrentID 当前节点
  @param param 子节点数据
  @return BOOL 是否追加成功
 */
- (BOOL)insertAfter:(NSString*)currrentID node:(WMZTreeParam*)param;

/*
 *为 Tree 的一个节点的前面增加一个节点
  @param currrentID 当前节点
  @param param 子节点数据
  @return BOOL 是否追加成功
 */
- (BOOL)insertBefore:(NSString*)currrentID node:(WMZTreeParam*)param;

/*
 *删除节点
  @param currrentID 当前节点
  @return BOOL 是否追加成功
 */
- (BOOL)remove:(NSString*)currrentID;


```

### 手风琴效果+指定层级可勾选 (这里选取3级结构,指定最后一级才可勾选)

![treeCanSelect.gif](https://upload-images.jianshu.io/upload_images/9163368-607e5c23e4c77b1e.gif?imageMogr2/auto-orient/strip)


```
//手风琴效果 同级只展开一级
TreeViewParam().wAccordionSet(YES)

//能否选择
TreeParam().canSelectSet(NO)
```
### 勾选不关联父节点和子节点+默认选中+默认全部展开

![treeCheck.gif](https://upload-images.jianshu.io/upload_images/9163368-c651d0107797fc8c.gif?imageMogr2/auto-orient/strip)

```
TreeViewParam()
//父节点和子节点 勾选不关联
.wCheckStrictlySet(NO)
//默认展开全部 
.wDefaultExpandAllSet(YES)
//默认勾选
.wDefaultExpandedKeysSet(@[@"5",@"10",@"12"])

```
### 开启拖拽( ️目前只支持没有子节点的节点拖拽,避免嵌套数据的bug, 如果有什么方便的办法可以支持多个连续的cell一起拖拽的告知下,不胜感激)
![treeDraggable.gif](https://upload-images.jianshu.io/upload_images/9163368-5c6a589140e7078a.gif?imageMogr2/auto-orient/strip)

```
TreeViewParam()
//拖拽
.wDraggableSet(YES)
```

## 配置参数和方法

| 可配置参数               | 类型      | 作用                                                    |
|------------------------|-----------|--------------------------------------------------------|
| wData                | NSArray      | 展示数据 必传                |
| wFrame                | CGRect      | frame  必传                              |
| wEmptyData      | NSDictionary      | 内容为空的时候展示的数据 default nil  (image为图片 name为文字)                                    |
| wHighlightCurrent             | UIColor      | 高亮当前选中节点颜色，default nil    |
| wNodeTextFont            | CGFloat      | 节点的字体大小 default 15.0f |
| wNodeTextColor                | UIColor      | 节点的字体颜色 default 333333                |
| wDefaultExpandAll                | BOOL      | 是否默认展开所有节点  default NO                                |
| wCheckStrictly      | BOOL      | 在显示复选框的情况下，是否严格的遵循父子互相关联的做法，defualt为 YES                                   |
| wHideExpanIcon             | BOOL      | 隐藏展开图标，defualt为 NO     |
| wShowCheckbox            | BOOL      | 节点是否可被选择 default NO |
| wAccordion                | BOOL      | 是否每次只打开一个同级树节点展开 手风琴效果 default NO             |
| wDraggable                | BOOL      | 是否允许拖动cell，默认为NO                                |
| wDefaultExpandedKeys      | NSArray      | 默认展开的节点的 key 的数组 default nil                                    |
| wIndent             | NSInteger      | 相邻级节点间的水平缩进距离  默认2    |
| wExpandIcon            | NSString      | 自定义树节点的图标 |
| wSelectExpandIcon      | NSString      | 自定义树节点展开的图标                                  |
| wCheckIcon             | NSString      | 自定义树节点未勾选的图标     |
| wSelectCheckIcon            | NSString      | 自定义树节点勾选的图标|
| wHalfSelectCheckIcon      | NSString      | 自定义树节点半选中的图标 (没有全选)                                 |

| 可监听block事件                  | 作用                                                    |
|------------------------|--------------------------------------------------------|
| wEventTreeCell                     | 自定义节点cell                |
| wEventCellUserEnabled                     | 自定义cell其他交互                              |
| wEventCellHeight         | 自定义cell高度                                  |
| wEventNodeClick                  | 节点被点击时的回调                |
| wEventNodeDraggable                 | 节点拖拽完成回调                               |
| wEventCheckChange        | 节点选中状态发生变化时的回调                                 |

| 实例方法                     | 作用                                                    |
|------------------------|--------------------------------------------------------|
| initWithParam                    | 初始化               |
| updateKeyChildren               | 更新或者设置子节点数组                               |
| getCheckedNodesWithHalfSelect          | 获取当前选中的节点数组                                   |
| append                    | 为 Tree 中的一个节点追加一个子节点               |
| remove                 | 删除节点                  |
| insertBefore           | 为 Tree 的一个节点的前面增加一个节点                                   |
| insertAfter           | 为 Tree 的一个节点的后面增加一个节点                                   |
| updateEditing           | 更新编辑状态                                  |

# **模型层**  
1.WMZTreeParam
```
TreeParam()
.cueerntIdSet(@"1")
.parentIdSet(@"2")
.nameSet(@"第一级")
.canSelectSet(YES)
.isExpandSet(YES)
.dataSet(@"")
```

2.NSDictionary
```
@[@{
            @"name":@"1级",
            @"currentId":@"1",
            @"children":@[
                    @{
                        @"name":@"1_2_1级",
                        @"currentId":@"1_2_1",
                        @"parentId":@"1",
                        @"children":@[
                                           @{
                                               @"name":@"1_3_1级",
                                               @"currentId":@"1_3_1",
                                               @"parentId":@"1_2_1",
                                           },
                                           @{
                                               @"name":@"1_3_2级",
                                               @"currentId":@"1_3_2",
                                               @"parentId":@"1_2_1",
                                           },
                                          @{
                                               @"name":@"1_3_3级",
                                               @"currentId":@"1_3_3",
                                               @"parentId":@"1_2_1",
                                           },
                                   ]
                    },
                    @{
                        @"name":@"1_2_2级",
                        @"currentId":@"1_2_2",
                        @"parentId":@"1",
                    },
                   @{
                        @"name":@"1_2_3级",
                        @"currentId":@"1_2_3",
                        @"parentId":@"1",
                    },
            ]
    }]
```

## 配置参数
| 可配置参数               | 类型      | 作用                                                    |
|------------------------|-----------|--------------------------------------------------------|
| cueerntId                | NSString      | 当前节点ID 必传              |
| parentId                | NSString      | 父节点ID,不传表示第一级                       |
| name      | NSString      | 显示的文本                                  |
| isExpand             | BOOL      | 是否展开 默认NO  |
| canSelect            | BOOL      | 能否选中 默认NO |
| data            | id      | 携带的其他数据|

### 其他具体看demo

### 依赖
无任何依赖 

安装
==============

### CocoaPods
1. 将 cocoapods 更新至最新版本.
2. 在 Podfile 中添加 `pod 'WMZTreeView'`。
3. 执行 `pod install` 或 `pod update`。
4. 导入 #import "WMZTreeView.h"。

### 注:要消除链式编程的警告 
要在Buildding Settings 把CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF 设为NO

### 手动安装

1. 下载 WMZTreeView 文件夹内的所有内容。
2. 将 WMZTreeView 内的源文件添加(拖放)到你的工程。
3. 导入 #import "WMZTreeView.h"

系统要求
==============
该库最低支持 `iOS 9.0` 和 `Xcode 9.0`。



许可证
==============
使用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。


个人主页
==============
使用过程中如果有什么bug欢迎给我提issue 我看到就会解决
[简书地址](https://www.jianshu.com/p/dedf610739be)
