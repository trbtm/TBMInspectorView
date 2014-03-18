Pod::Spec.new do |s|
    s.name = 'TBMInspectorView'
    s.version = '1.0.0'
    s.platform = :osx, '10.6'
    s.authors = {'Thore Bartholomäus' => 'thore.bar@googlemail.com'}
    s.license = {:type => 'MIT'}
    s.homepage = 'https://github.com/trbtm/TBMInspectorView'
    s.summary = 'TBMInspectorView is a copy of the Xcode 5s inspector view. It is pretty easy to setup and should be set as the documentView of a NSScrollView.'
    s.source = {:git => 'git://github.com/trbtm/TBMInspectorView', :tag => 'v1.0.0'}
    s.source_files = 'Classes/*.{h,m}'
    s.requires_arc = false
end