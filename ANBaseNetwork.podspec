Pod::Spec.new do |s|
    s.name = 'ANBaseNetwork'
    s.version = '2.0.0'
    s.license = 'MIT'
    s.summary = 'ANBaseNetwork'
    s.homepage = 'https://github.com/anotheren/ANBaseNetwork'
    s.authors = {
        'anotheren' => 'liudong.edward@gmail.com',
    }
    s.source = { :git => 'https://github.com/anotheren/ANBaseNetwork.git', :tag => s.version }
    s.ios.deployment_target = '10.0'
    s.swift_versions = ['5.0', '5.1']
    s.source_files = 'Sources/**/*.swift'
    s.frameworks = 'Foundation'
    s.dependency 'Alamofire', '5.0.0-rc.3'
  end
