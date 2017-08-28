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

open class ApplicationAssembly: TyphoonAssembly {

    //-------------------------------------------------------------------------------------------
    // MARK: - Bootstrapping
    //-------------------------------------------------------------------------------------------


    /*
     * These are modules - assemblies collaborate to provie components to this one.  At runtime you
     * can instantiate Typhoon with any assembly tha satisfies the module interface.
     */
    open var coreComponents: CoreComponents!
    open var themeAssembly: ThemeAssembly!


    /* 
     * This is the definition for our AppDelegate. Typhoon will inject the specified properties 
     * at application startup. 
     */
    open dynamic func appDelegate() -> Any {
        return TyphoonDefinition.withClass(AppDelegate.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }
            d.injectProperty(#selector(getter: AppDelegate.cityDao), with: self.coreComponents.cityDao())
            d.injectProperty(#selector(getter: AppDelegate.rootViewController), with: self.rootViewController())
        }
    }


    /*
     * A config definition, referencing properties that will be loaded from a plist. 
     */
    open dynamic func config() -> AnyObject {

        return TyphoonDefinition.configDefinition(withName: "Configuration.plist")
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Main Assembly
    //-------------------------------------------------------------------------------------------

    open dynamic func rootViewController() -> Any {
        return TyphoonDefinition.withClass(RootViewController.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }
            d.useInitializer(#selector(RootViewController.init(mainContentViewController:assembly:))) { initializer in
                guard let i = initializer else {
                    fatalError("TyphoonDefinition object creation error")
                }
                i.injectParameter(with: self.weatherReportController())
                i.injectParameter(with: self)
            }
            d.scope = TyphoonScope.singleton
        }
    }

    open dynamic func citiesListController() -> Any {

        return TyphoonDefinition.withClass(CitiesListViewController.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.useInitializer(#selector(CitiesListViewController.init(cityDao:theme:))) { initializer in
                guard let i = initializer else {
                    fatalError("TyphoonDefinition object creation error")
                }

                i.injectParameter(with: self.coreComponents.cityDao())
                i.injectParameter(with: self.themeAssembly.currentTheme())
            }
            d.injectProperty(#selector(getter: CitiesListViewController.assembly))
        }

    }


    open dynamic func weatherReportController() -> Any {

        return TyphoonDefinition.withClass(WeatherReportViewController.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.useInitializer(#selector(WeatherReportViewController.init(view:weatherClient:weatherReportDao:cityDao:assembly:))) { initializer in
                guard let i = initializer else {
                    fatalError("TyphoonDefinition object creation error")
                }

                i.injectParameter(with: self.weatherReportView())
                i.injectParameter(with: self.coreComponents.weatherClient())
                i.injectParameter(with: self.coreComponents.weatherReportDao())
                i.injectParameter(with: self.coreComponents.cityDao())
                i.injectParameter(with: self)

            }
        };
    }

    open dynamic func weatherReportView() -> Any {

        return TyphoonDefinition.withClass(WeatherReportView.self) {
            (definition) in

            definition!.injectProperty(#selector(getter: WeatherReportView.theme), with: self.themeAssembly.currentTheme())
        }
    }

    open dynamic func addCityViewController() -> Any {

        return TyphoonDefinition.withClass(AddCityViewController.self) { definition in
            
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            // TODO: Seems sub-class MUST override this initializer otherwise it can't be
            // TODO: invoked in RELEASE configuration. Bug?
            d.useInitializer(#selector(AddCityViewController.init(nibName:bundle:))) { initializer in

                initializer!.injectParameter(with: "AddCity")
                initializer!.injectParameter(with: Bundle.main)
            }


            d.injectProperty(#selector(getter: AddCityViewController.cityDao), with: self.coreComponents.cityDao())
            d.injectProperty(#selector(getter: AddCityViewController.weatherClient), with: self.coreComponents.weatherClient())
            d.injectProperty(#selector(getter: AddCityViewController.theme), with: self.themeAssembly.currentTheme())
            d.injectProperty(#selector(getter: AddCityViewController.rootViewController), with: self.rootViewController())
        }
    }
}
