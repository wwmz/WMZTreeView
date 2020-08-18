Pod::Spec.new do |s|

  s.name         = "WMZTreeView"
  s.version      = "1.0.3"
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.license      = "Copyright (c) 2019年 WMZ. All rights reserved."
  s.summary      = "类似前端elementUI的树形控件,可自定义节点内容,支持无限极节点,可拖拽增删节点等待,非递归实现
"
  s.description  = <<-DESC 
                   可自定义节点内容,支持无限极节点,可拖拽增删节点等待,非递归实现
                   注：Building Settings设置CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF为NO可以消除链  式编程的警告
                   DESC
  s.homepage     = "https://github.com/wwmz/WMZTreeView"
  s.license      = "MIT"
  s.author       = { "wmz" => "925457662@qq.com" }
  s.source       = { :git => "https://github.com/wwmz/WMZTreeView.git", :tag => s.version.to_s }
  s.source_files = "WMZTreeView/WMZTreeView/**/*.{h,m}"
  s.resources     = "WMZTreeView/WMZTreeView/WMZTreeView.bundle"
  s.framework = 'UIKit'
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

end
