
Pod::Spec.new do |s|

    s.name             = 'SDMenuBarViewKit'
    s.version          = '0.0.2'
    s.summary          = '带有公共头部,顶部菜单并且可以横向滚动切换tableView类库'
    s.homepage         = 'https://github.com/sudaotech/SDMenuBarViewKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'sfuser' => 'chenkefeng@kuaicto.com' }
    s.source           = { :git => 'https://github.com/sudaotech/SDMenuBarViewKit.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.source_files = 'SDMenuBarViewKit/Classes/**/*'

end
