//Store locator application 
//REQUIRES gmap3 for mapping data
window.bmStoreLocator = (function() {
    'use strict';
    /**
     * Public variables
     */
    var bmStoreLocator = {
        errors : []         //Log any issues here to prevent and console.log conflicts
    };

    /**
     * Start the application
     * @returns {undefined}
     */
    bmStoreLocator.load = function() {
        //Pass all filtering query params in the URL to the mapping application
        var params = '';
        $.each(window.urlParams , function(key,value){
            params += '&' + key + '=' + value;
        });
        
        //Fetch the location data from the map location API
        $.ajax({
            url: '##REMOVED##' + params,
            success: function(data) {
                //Make sure this area has at least 1 location
                if (data.length > 1) {
                    //Show the map
                    $('#map').slideDown(function() {
                        //Now load the data returned from the API into the map object
                        loadMap(data);
                    });
                    //Fade in the legend
                    $('.legend').fadeIn();
                }
            },
            //Log any errors to object
            error: function(xhr, err) {
                bmStoreLocator.errors.push(xhr);
                bmStoreLocator.errors.push(err);
            }
        });
        
        //Load analytics
        analytics.trackPage();
        analytics.trackEvents();
    };
    
    /**
     * Load the data returned from the servlet into the map application. Requires gmap3 to be loaded first.
     * @param {json} data - A json object containing the location data
     * @returns {undefined}
     */
    var loadMap = function(data) {
        //Create the map entity
        $("#map").gmap3({
            map: {},
            //Create map markets for each entry in the data objt
            marker: {
                values: data,
                options: {
                    draggable: false
                },
                events: {
                    //On clickevent, show a tooltip
                    click: function(marker, event, context) {
                        var map = $(this).gmap3("get"),
                                infowindow = $(this).gmap3({get: {name: "infowindow"}});
                        if (infowindow) {
                            infowindow.open(map, marker);
                            infowindow.setContent(context.data);
                        } else {
                            $(this).gmap3({
                                infowindow: {
                                    anchor: marker,
                                    options: {content: context.data}
                                }
                            });
                        }
                    },
                    //Close tooltip on mouseout        
                    mouseout: function() {
                        var infowindow = $(this).gmap3({get: {name: "infowindow"}});
                        if (infowindow) {
                            //infowindow.close();
                        }
                    }
                }
            }
        }, "autofit"); //Center and size map to contain map points
    };//end loadMap
    
    
    //Object to contain analytics methods
    //Requires omniture's s_code.js
    var analytics = {
        /**
         * Onload analytics data. Different information needs to be supplied to omniture depending on the state of the application
         * @returns {undefined}
         */
        trackPage: function() {
            window.s.channel = 'Store Locator';
            //locationData object is being output by the XSL template file into the HTML on the page
            //Direct page load with no zip code present
            if(window.locationData.params === ''){
                window.s.pageName = 'Store Locator > Find A Store';
                window.s.prop34 = 'Missing: No Zip Entered';
            //Invalid or missing zip code
            } else if (window.locationData.valid === false) {
                window.s.pageName = 'Store Locator > Invalid Entry';
                window.s.prop34 = 'Invalid: '+window.urlParams.zipcode;
            //Valid zip but no locations  
            } else if (window.locationData.locations === false) {
                window.s.pageName = 'Store Locator > No Results';
                //locationData is being output by the XSL template file into the HTML on the page
                window.s.prop34 = window.locationData.zip + ' | ' + window.locationData.cityState;
            //Valid zip and locations returned    
            } else {
                window.s.pageName = 'Store Locator > Store Locator Results';
                window.s.prop34 = window.locationData.zip + ' | ' + window.locationData.cityState;
                //window.s.prop23=phones | reboost cards| mobile wallet reload
                window.s.prop23 = $('#locatorFormOptions input[checked="true"]').next().text().trim().split(' ').join(' | ');
            }
            //Submit data
            analytics.submit();
        },
        
        /**
         * Analytics for event tracking
         * @returns {undefined}
         */
        trackEvents: function(){
            //When a featured location is clicked on
            $('#locatorFeatured a').on('click',function(){
                //Allow link tracking for prop29
                window.s.linkTrackVars = 'prop29';
                //window.s.prop29 = Store Locator > Store Locator Results > Featured Store <<#>> > <<Name of Store>> 
                var index = $(this).index('#locatorFeatured a') + 1;
                window.s.prop29 = 'Store Locator > Store Locator Results > Featured Store' + ' ' + index + ' ' + $(this).closest('li').find('h2').text();
                analytics.submit('click');
            });
        },
                
        /**
         * Sends the data to omniture
         * @param {type} type - (Optional) String - can be set to 'click' to use the omniture click event instead
         * @returns {undefined}
         */
        submit: function(type) {
            //Determine if this is an onclick or onload event to pass
            if (type === 'click') {
               window.s.tl(this,'o','Click');
               window.s.linkTrackVars = '';
            } else {
                window.s.t();
            }
        }
    };
    
    //Start application
    bmStoreLocator.load();

    //Make API public
    return bmStoreLocator;
})();