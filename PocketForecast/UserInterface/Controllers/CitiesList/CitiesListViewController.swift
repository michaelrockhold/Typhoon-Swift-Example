////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

open class CitiesListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, Themeable {
    
    let celciusSegmentIndex = 0
    let fahrenheitSegmentIndex = 1
    
    //Typhoon injected properties
    var cityDao : CityDao!
    open var theme : Theme!
    dynamic var assembly : ApplicationAssembly!
    
    
    //Interface Builder injected properties
    @IBOutlet var citiesListTableView : UITableView!
    @IBOutlet var temperatureUnitsControl : UISegmentedControl!
    
    var cities : [String]?
    
    init(cityDao : CityDao, theme : Theme) {
        super.init(nibName: "CitiesList", bundle: Bundle.main)
        self.cityDao = cityDao
        self.theme = theme
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    open override func viewDidLoad() {
        self.title = "Pocket Forecast"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(CitiesListViewController.addCity))
        self.citiesListTableView.isEditing = true
        self.temperatureUnitsControl.addTarget(self, action: #selector(CitiesListViewController.saveTemperatureUnitPreference), for: UIControlEvents.valueChanged)
        if (Temperature.defaultUnits() == TemperatureUnits.celsius) {
            self.temperatureUnitsControl.selectedSegmentIndex = celciusSegmentIndex
        }
        else {
            self.temperatureUnitsControl.selectedSegmentIndex = fahrenheitSegmentIndex
        }
        self.applyTheme()
    }
    

    open override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        self.refreshCitiesList()
        let cityName : String? = cityDao.loadSelectedCity()
        if (cityName != nil) {
            
            let indexPath = IndexPath(row: cities!.index(of: cityName!)!, section: 0)
            self.citiesListTableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ca = self.cities else {
            return 0
        }
        return ca.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseId = "Cities"
        var cell : CityTableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseId) as? CityTableViewCell
        if (cell == nil) {
            cell = CityTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseId)
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.gray
        cell!.cityLabel.backgroundColor = UIColor.clear
        cell!.cityLabel.font = UIFont.applicationFontOfSize(16)
        cell!.cityLabel.textColor = UIColor.darkGray
        cell!.cityLabel.text = cities![indexPath.row]
        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
  
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityName = cities![indexPath.row]
        cityDao.saveCurrentlySelectedCity(cityName)
        
        let rootViewController = self.assembly.rootViewController() as! RootViewController
        rootViewController.dismissCitiesListController()
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let city = cities![indexPath.row]
            self.cityDao.deleteCity(city)
            self.refreshCitiesList()
        }
    }

    fileprivate dynamic func addCity() {
        
        let rootViewController = self.assembly.rootViewController() as! RootViewController
        rootViewController.showAddCitiesController()
    }
    
    fileprivate func refreshCitiesList() {
        self.cities = self.cityDao.listAllCities()
        self.citiesListTableView.reloadData()
    }
    
    fileprivate dynamic func saveTemperatureUnitPreference() {
        if (self.temperatureUnitsControl.selectedSegmentIndex == celciusSegmentIndex) {
            Temperature.setDefaultUnits(TemperatureUnits.celsius)
        }
        else {
            Temperature.setDefaultUnits(TemperatureUnits.fahrenheit)
        }
    }
    
    fileprivate func applyTheme() {
        self.temperatureUnitsControl.tintColor = self.theme.controlTintColor
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.barTintColor = self.theme.navigationBarColor
    }
    

}
