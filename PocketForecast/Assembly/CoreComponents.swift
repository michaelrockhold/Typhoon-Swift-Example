////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


open class CoreComponents : TyphoonAssembly {
    
    open dynamic func weatherClient() -> Any {
        return TyphoonDefinition.withClass(WeatherClientBasicImpl.self) { definition in
            
            guard let def = definition else {
                fatalError("TyphoonDefinition object creation error")
            }
            def.injectProperty(#selector(getter: WeatherClientBasicImpl.serviceUrl),        with:TyphoonConfig("service.url"))
            def.injectProperty(#selector(getter: WeatherClientBasicImpl.apiKey),            with:TyphoonConfig("api.key"))
            def.injectProperty(#selector(getter: WeatherClientBasicImpl.weatherReportDao),  with:self.weatherReportDao())
            def.injectProperty(#selector(getter: WeatherClientBasicImpl.daysToRetrieve),    with:TyphoonConfig("days.to.retrieve"))
        }
    }
    
    open dynamic func weatherReportDao() -> Any {
        return TyphoonDefinition.withClass(WeatherReportDaoFileSystemImpl.self) as Any
    }
    
    open dynamic func cityDao() -> Any {
        
        return TyphoonDefinition.withClass(CityDaoUserDefaultsImpl.self) { definition in
            definition?.useInitializer(#selector(CityDaoUserDefaultsImpl.init(defaults:))) { initializer in
                initializer?.injectParameter(with:UserDefaults.standard)
            }
        }
    }

}
