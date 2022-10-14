## UI效果仿照前端element-UI的[Tree控件](https://element.eleme.cn/#/zh-CN/component/tree)
 [![Platform](https://img.shields.io/badge/platform-iOS-red.svg)](https://developer.apple.com/iphone/index.action) 
 [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WMZTreeView.svg)](https://img.shields.io/cocoapods/v/WMZTreeView.svg)
 [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://mit-license.org) 

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
### 开启拖拽
![treeDraggable.gif](https://upload-images.jianshu.io/upload_images/9163368-5c6a589140e7078a.gif?imageMogr2/auto-orient/strip)

```
TreeViewParam()
//拖拽
.wDraggableSet(YES)
```

# **模型层**  
1 任意模型实现WMZTreeProcotol协议
```
参考WMZCustomModel
```
1.使用或继承WMZTreeParam （已经实现了WMZTreeProcotol协议）
```
WMZTreeParam *tree = WMZTreeParam.new;
tree.cueerntId =  @"1";
tree.parentId =  @"2";
tree.name =  @"第一级";
```

2.NSDictionary
```
    @[
        @{
            WMZTreeName:@"1级",
            WMZTreeCurrentId:@"1",
            WMZTreeChildren:@[
                    @{
                        WMZTreeName:@"1_2_1级",
                        WMZTreeCurrentId:@"1_2_1",
                        WMZTreeParentId:@"1",
                        WMZTreeChildren:@[
                                           @{
                                               WMZTreeName:@"1_3_1级",
                                               WMZTreeCurrentId:@"1_3_1",
                                               WMZTreeParentId:@"1_2_1",
                                           },
                                           @{
                                               WMZTreeName:@"1_3_2级",
                                               WMZTreeCurrentId:@"1_3_2",
                                               WMZTreeParentId:@"1_2_1",
                                           },
                                          @{
                                               WMZTreeName:@"1_3_3级",
                                               WMZTreeCurrentId:@"1_3_3",
                                               WMZTreeParentId:@"1_2_1",
                                           },
                                   ]
                    },
                    @{
                        WMZTreeName:@"1_2_2级",
                        WMZTreeCurrentId:@"1_2_2",
                        WMZTreeParentId:@"1",
                    },
                   @{
                        WMZTreeName:@"1_2_3级",
                        WMZTreeCurrentId:@"1_2_3",
                        WMZTreeParentId:@"1",
                    },
            ]
        },
        @{
            WMZTreeName:@"2级",
            WMZTreeCurrentId:@"2",
            WMZTreeChildren:@[
                    @{
                        WMZTreeName:@"2_2_1级",
                        WMZTreeCurrentId:@"2_2_1",
                        WMZTreeParentId:@"2",
                    },
                    @{
                        WMZTreeName:@"2_2_2级",
                        WMZTreeCurrentId:@"2_2_2",
                        WMZTreeParentId:@"2",
                    },
                   @{
                        WMZTreeName:@"2_2_3级",
                        WMZTreeCurrentId:@"2_2_3",
                        WMZTreeParentId:@"2",
                    },
            ]
        },
        @{
            WMZTreeName:@"3级",
            WMZTreeCurrentId:@"3",
            WMZTreeChildren:@[
                    @{
                        WMZTreeName:@"3_2_1级",
                        WMZTreeCurrentId:@"3_2_1",
                        WMZTreeParentId:@"3",
                    },
                    @{
                        WMZTreeName:@"3_2_2级",
                        WMZTreeCurrentId:@"3_2_2",
                        WMZTreeParentId:@"3",
                    },
                   @{
                        WMZTreeName:@"3_2_3级",
                        WMZTreeCurrentId:@"3_2_3",
                        WMZTreeParentId:@"3",
                    },
            ]
        }
    ]
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
