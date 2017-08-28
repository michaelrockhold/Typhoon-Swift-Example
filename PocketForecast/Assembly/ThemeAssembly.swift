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

import Foundation

open class ThemeAssembly : TyphoonAssembly {
    

    /**
     * Current-theme is emitted from the theme-factory, which increments the theme on each run of the application.
     */
    open dynamic func currentTheme() -> Any {

        return TyphoonDefinition.withFactory(self.themeFactory(), selector: #selector(ThemeFactory.sequentialTheme))
    }

    /**
    * The theme factory contains a collection of each theme. Individual themes are using Typhoon's type-converter system to convert the
    * string representation of properties to their required runtime type.
    */
    open dynamic func themeFactory() -> Any {
        return TyphoonDefinition.withClass(ThemeFactory.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.useInitializer(#selector(ThemeFactory.init(themes:))) { initializer in
                guard let i = initializer else {
                    fatalError("TyphoonDefinition object creation error")
                }

                i.injectParameter(with: [
                    self.cloudsOverTheCityTheme(),
                    self.lightsInTheRainTheme(),
                    self.beachTheme(),
                    self.sunsetTheme()
                    ])
            }
            d.scope = TyphoonScope.singleton
        }
    }


    open dynamic func cloudsOverTheCityTheme() -> Any {
        return TyphoonDefinition.withClass(Theme.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.injectProperty(#selector(getter: Theme.backgroundResourceName), with:"bg3.png")
            d.injectProperty(#selector(getter: Theme.navigationBarColor), with:UIColor(hexRGB:0x641d23))
            d.injectProperty(#selector(getter: Theme.forecastTintColor), with:UIColor(hexRGB:0x641d23))
            d.injectProperty(#selector(getter: Theme.controlTintColor), with:UIColor(hexRGB:0x7f9588))
        }
    }


    open dynamic func lightsInTheRainTheme() -> Any {
        return TyphoonDefinition.withClass(Theme.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.injectProperty(#selector(getter: Theme.backgroundResourceName), with:"bg4.png")
            d.injectProperty(#selector(getter: Theme.navigationBarColor), with:UIColor(hexRGB:0xeaa53d))
            d.injectProperty(#selector(getter: Theme.forecastTintColor), with:UIColor(hexRGB:0x722d49))
            d.injectProperty(#selector(getter: Theme.controlTintColor), with:UIColor(hexRGB:0x722d49))
        }

    }


    open dynamic func beachTheme() -> Any {
        return TyphoonDefinition.withClass(Theme.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.injectProperty(#selector(getter: Theme.backgroundResourceName), with:"bg5.png")
            d.injectProperty(#selector(getter: Theme.navigationBarColor), with:UIColor(hexRGB:0x37b1da))
            d.injectProperty(#selector(getter: Theme.forecastTintColor), with:UIColor(hexRGB:0x37b1da))
            d.injectProperty(#selector(getter: Theme.controlTintColor), with:UIColor(hexRGB:0x0043a6))
        }

    }

    open dynamic func sunsetTheme() -> Any {
        return TyphoonDefinition.withClass(Theme.self) { definition in
            guard let d = definition else {
                fatalError("TyphoonDefinition object creation error")
            }

            d.injectProperty(#selector(getter: Theme.backgroundResourceName), with:"sunset.png")
            d.injectProperty(#selector(getter: Theme.navigationBarColor), with:UIColor(hexRGB:0x0a1d3b))
            d.injectProperty(#selector(getter: Theme.forecastTintColor), with:UIColor(hexRGB:0x0a1d3b))
            d.injectProperty(#selector(getter: Theme.controlTintColor), with:UIColor(hexRGB:0x606970))
        }
    }
    
}
