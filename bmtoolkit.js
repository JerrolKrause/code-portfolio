/*  
 * This application is a dynamic resource loader which is used to insert 3rd party resources in our environments
 * The code in this file needs to work on a variety of environments including some poorly developed ones without breaking anything. 
 * That requirement dictated some overdevelopment and additional error proofing that wouldn't ordinarily be required
 * This is the production file. When finished and ready for prod, minify to toolkit.min.js. 
 */

window.bmToolkit = (function() {
    'use strict';
    var bmToolkit = {};

    //Public variables
    bmToolkit.vars = {
        domain : window.location.host,            //Get current domain
        pathName : window.location.pathname,      //Get current page
        resourcesURL : 'www.boostmobile.com',     //Var to override to test loading resources in non prod environments
        pixel : '',                               //Debugging only, list pixel of doubleclick tag for this page (if present)
        resources : [],                           //Array to hold assets/files inserted in the page
        resourcesLoaded : 0,                      //Number of assets that have been currently loaded
        resourcesTotal : 0,                       //Total number of assets to be loaded
        loops : 0,                                //Keeps track of load attempts by bmToolkit.resources.load. This is used to prevent that function from trying to load indefinitely in the event of an error or unexpected behavior
        cookies : {}                              //If the current page sets a cookie, record it here
    };


    //Staging vars - Use to override current page for testing. Uncomment to override.
    //bmToolkit.vars.domain = 'apps.boostmobile.com';
    //bmToolkit.vars.pathName = '/boostApp/confirmationDisplay.do';


    /**
     * Object containing all the domains associated with bm.com. Each set of domains is grouped. Be sure to create a function for each item. 
     * domains - An array of all associated dev AND prod domains
     * prodDomain - The prod domain of this group. This way it knows to fire the prod or dev resource call
     * devResourceUrl - The path/URL to use for resources (css/js) when in a dev environment
     */
    var domains = {
        www: {
            domains: ['localhost:8080', '##REMOVED##', '##REMOVED##', '##REMOVED##', '##REMOVED##', 'www.boostmobile.com'],
            prodDomain: 'www.boostmobile.com',
            devResourceUrl: bmToolkit.vars.domain
        },
        checkout: {
            domains: ['checkout.booststaging.com', 'checkout.boostmobile.com'],
            prodDomain: 'checkout.boostmobile.com',
            devResourceUrl: '##REMOVED##' //Using RTB instead of test because test doesn't have a valid SSL Cert
        },
        espanol: {
            domains: ['espanol.boostmobile.com'],
            prodDomain: 'espanol.boostmobile.com',
            devResourceUrl: '##REMOVED##'
        },
        myaccount: {
            domains: ['myaccount.boostmobile.com'],
            prodDomain: 'myaccount.boostmobile.com',
            devResourceUrl: '##REMOVED##'
        },
        apps: {
            domains: ['apps.boostmobile.com'],
            prodDomain: 'apps.boostmobile.com',
            devResourceUrl: '##REMOVED##'
        },
        devicehelp: {
            domains: ['devicehelp.boostmobile.com'],
            prodDomain: 'devicehelp.boostmobile.com',
            devResourceUrl: '##REMOVED##'
        }
    };


    /************************************
     * Public Functions
     ************************************/

    /**
     * Checks for which domain we are on, fire appropriate domain code
     * @returns {none}
     */
    bmToolkit.initialize = function() {
        //Loop through items in the domains object
        for (var key in domains) {
            if (domains.hasOwnProperty(key)) {//Don't transverse the prototype
                //Check if the current domain is in the domain group
                var index = helpers.indexOf(domains[key].domains, bmToolkit.vars.domain);
                //If the domain was found in the array
                if (index !== -1) {
                    //Check if the current domain matches the prod domain
                    if (domains[key].domains[index] !== domains[key].prodDomain) {
                        //If not, set the resources URL to use the dev resources url
                        bmToolkit.vars.resourcesURL = domains[key].devResourceUrl;
                    }
                    bmToolkit.vars.domainFunction = key;//Load the domain key into the vars object, helps debugging for when code function is firing
                    //Execute this domain groups function
                    domains[key].code();
                    //Load universal assets in to resources object
                    bmToolkit.resources.all();
                    //Load all assets into page
                    bmToolkit.resources.load(bmToolkit.vars.resources);
                    break;
                }
            }
        }
    };//end initialize


    /************************************
     * Private Functions
     ************************************/

    /************************************
     * Domain classes and methods. Contains the code that gets executed in each environment. These methods load themselves into the domains var and correspond to the keys for each domain group
     ************************************/
    //Tracking codes needed on www.boostmobile.com
    domains.www.code = function() {
        //Check the current path against paths needing floodlight tags 
        switch (bmToolkit.vars.pathName) {
            case '/':
                bmToolkit.resources.floodlightTag('214');
                break;
            case '/shop/':
                //bmToolkit.resources.floodlightTag('401');  //Signal Test
                break;
            case '/shop/phones/':
                bmToolkit.resources.floodlightTag('002');
                break;
            case '/shop/phones/compare/':
                bmToolkit.resources.floodlightTag('812');
                break;
            case '/shop/accessories/':
                bmToolkit.resources.floodlightTag('334');
                break;
            case '/stores/':
                bmToolkit.resources.floodlightTag('904');
                break;
            case '/shop/plans/monthly-unlimited-select/':
                bmToolkit.resources.floodlightTag('685');
                break;
            case '/shop/plans/monthly-unlimited/50/':
                bmToolkit.resources.floodlightTag('341');
                break;
            case '/shop/plans/monthly-unlimited/55/':
                bmToolkit.resources.floodlightTag('027');
                break;
            case '/shop/plans/monthly-unlimited/60/':
                bmToolkit.resources.floodlightTag('311');
                break;
            case '/shop/plans/monthly-unlimited/45/':
                bmToolkit.resources.floodlightTag('736');
                break;
            case '/shop/plans/daily-unlimited/2/':
                bmToolkit.resources.floodlightTag('315');
                break;
            case '/shop/plans/daily-unlimited/3/':
                bmToolkit.resources.floodlightTag('067');
                break;
            case '/shop/plans/shrinking-payments/':
                bmToolkit.resources.floodlightTag('287');
                break;
            case '/shop/phones/apple-iphone/5s/':
                bmToolkit.resources.floodlightTag('726');
                break;
            case '/shop/phones/apple-iphone/5c/':
                bmToolkit.resources.floodlightTag('467');
                break;
            case '/shop/phones/apple-iphone/compare/':
                bmToolkit.resources.floodlightTag('155');
                break;
            case '/shop/phones/apple-iphone/plans/':
                bmToolkit.resources.floodlightTag('607');
                break;
            case '/certifiedpreowned/':
                bmToolkit.resources.floodlightTag('454');
                break;
            case '/shop/phones/htc-one-sv/':
                bmToolkit.resources.floodlightTag('674');
                break;
            case '/shop/phones/lg-optimus-f7/':
                bmToolkit.resources.floodlightTag('938');
                break;
            case '/shop/phones/moto-g/':        //Moto G
                bmToolkit.resources.floodlightTag('238');//moto G
                bmToolkit.resources.floodlightTag('271', 'motog', 'motog014', '3822063');//moto G
                break;
            case '/shop/phones/samsung-galaxy-prevail-2/':
                bmToolkit.resources.floodlightTag('343');
                break;
            case '/shop/plans/international-connect/':
                bmToolkit.resources.floodlightTag('485', 'xqnzu');
                break;
            case '/35plan/':
                bmToolkit.resources.floodlightTag('375');
                break;
            case '/vote/':
                bmToolkit.resources.floodlightTag('869');
                break;
            case '/m/vote/':
                bmToolkit.resources.floodlightTag('161');
                break;
            case '/reboost/':
                bmToolkit.resources.floodlightTag('00', 'Boost');
                break;

        }

        //jQuery is available on WWW but it's good to make sure
        if (window.jQuery) {
            //Fire on add to cart click
            $('.add_to_cart').click(function() {
                bmToolkit.resources.floodlightTag('091');
                bmToolkit.resources.load();//User generated events need to re-fire the load function
            });
            //Fire on add to cart click
            $('.addToCart a').click(function() {
                bmToolkit.resources.floodlightTag('091');
                bmToolkit.resources.load();//User generated events need to re-fire the load function
            });

            //Check if were on a phone detail page
            var phoneType = $('.phoneIntro').attr('data-phone-type');
            if (phoneType !== undefined) {
                bmToolkit.resources.floodlightTag('847');
                //Add tags for a phone type
                switch (phoneType)
                {
                    case 'feature':
                        bmToolkit.resources.floodlightTag('673');
                        break;
                    case 'android':
                        bmToolkit.resources.floodlightTag('273');
                        break;
                    case 'blackberry':
                        bmToolkit.resources.floodlightTag('629');
                        break;
                }
            }
        }

        //Google site search
        var resource = document.createElement('script');
        resource.type = 'text/javascript';
        resource.async = true;
        resource.src = '//www.google.com/cse/cse.js?cx=017156821116155704347:e0grp0gsys4';
        bmToolkit.resources.store(resource);

    };//end domains.www

    //Tracking code on BP controlled checkout
    domains.checkout.code = function() {
        //Check the current path against paths needing floodlight tags 
        switch (bmToolkit.vars.pathName) {
            case '/bpdirect/boost/AddItem.do':
                bmToolkit.resources.floodlightTag('937');
                bmToolkit.resources.floodlightTag('978', 'motog', 'motog014', '3822063');//moto G
                break;
            case '/bpdirect/boost/Confirm.do':
                bmToolkit.resources.floodlightTag('368');
                bmToolkit.resources.floodlightTag('363', 'motog', 'motog014', '3822063');//moto G
                break;
            case '/bpdirect/boost/Complete.do':
                bmToolkit.resources.floodlightTag('360', 'motog', 'motog014', '3822063');//moto G
                break
        }
    };//end domains.checkout

    //Tracking code on Motionpoint controlled site
    domains.espanol.code = function() {
        //Check the current path against paths needing floodlight tags 
        switch (bmToolkit.vars.pathName) {
            case '/':
                bmToolkit.resources.floodlightTag('226');
                break;
            case '/shop/plans/international-connect/':
                bmToolkit.resources.floodlightTag('295');
                break;
            case '/sdapps/boostApp/accountLogin.do':
                bmToolkit.resources.floodlightTag('497');
                break;
            case '/shop/plans/monthly-unlimited-select/':
                bmToolkit.resources.floodlightTag('855');
                break;
            case '/35plan/':
                bmToolkit.resources.floodlightTag('339');
                break;
            case '/shop/':
                bmToolkit.resources.floodlightTag('972');
                break;
            case '/shop/phones/':
                bmToolkit.resources.floodlightTag('667');
                break;
            case '/shop/plans/monthly-unlimited/50/':
                bmToolkit.resources.floodlightTag('649');
                break;
            case '/sdapps/boostApp/myAccount.do':
                bmToolkit.resources.floodlightTag('325');
                break;
        }

        if (window.jQuery) {
            //Fire on add to cart click
            $('.add_to_cart, .addToCart a').click(function() {
                bmToolkit.resources.floodlightTag('753');
                bmToolkit.resources.load();//User generated events need to re-fire the load function
            });
        }

        //Google site search, spanish key
        var resource = document.createElement('script');
        resource.type = 'text/javascript';
        resource.async = true;
        resource.src = '//www.google.com/cse/cse.js?cx=017156821116155704347:9vyxq0md_-e';
        bmToolkit.resources.store(resource);
    };//end domains.espanol

    //Tracking code on Amdocs controlled myaccount site
    //NOTE, there are 2 subdomains involved with myaccount. apps.bm.com is the login page, myaccount.bm.com is the actual myaccount page
    domains.myaccount.code = function() {
        //Check the current path against paths needing floodlight tags
        switch (bmToolkit.vars.pathName) {
            case '/servlet/ecare':
                bmToolkit.resources.floodlightTag('484');
                break;
        }
        //Set customer cookie
        helpers.setCookie('BoostMobileCustomer', 'true', 90, '/', '.boostmobile.com');
    };//end domains.myaccount

    //Code for activation/apps subdomain
    domains.apps.code = function() {
        //Check the current path against paths needing floodlight tags
        switch (bmToolkit.vars.pathName) {
            case '/boostApp/confirmationDisplay.do':
                bmToolkit.resources.floodlightTag('499');
                break;
            case '/boostApp/accountLogin.do':
                bmToolkit.resources.floodlightTag('163');
                try {
                    window.google_conversion_id = 963322233;
                    window.google_conversion_label = "Xf4WCI_lxQkQ-cKsywM";
                    window.google_custom_params = window.google_tag_params;
                    window.google_remarketing_only = true;
                } catch (err) {
                }
                var rvGoogle = document.createElement('script');
                rvGoogle.type = 'text/javascript';
                rvGoogle.async = true;
                rvGoogle.src = '//www.googleadservices.com/pagead/conversion.js';
                bmToolkit.resources.store(rvGoogle);

                //<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/963322233/?value=1.00&amp;label=Xf4WCI_lxQkQ-cKsywM&amp;guid=ON&amp;script=0"/>
                var rvGoogleImg = document.createElement('img');
                rvGoogleImg.src = '//googleads.g.doubleclick.net/pagead/viewthroughconversion/963322233/?value=1.00&label=Xf4WCI_lxQkQ-cKsywM&guid=ON&script=0';
                rvGoogleImg.height = '0px';
                rvGoogleImg.width = '0px';
                bmToolkit.resources.store(rvGoogleImg);
                break;
        }
    };//end domains.apps

    //Code for activation/apps subdomain
    domains.devicehelp.code = function() {

    };//end domains.apps


    /************************************
     * Resources classes and methods. Manages the code that creates and inserts DOM content/scripts/tags/etc
     ************************************/
    bmToolkit.resources = {
        /**
         * Generates a floodlight tag and loads into the resources object
         * @param {type} pixelNum - unique number of the floodlight tag
         * @param {type} category - optional, category query param
         * @param {type} type - optional, type query param
         * @param {type} account - optional, account query param
         * @returns {undefined}
         */
        floodlightTag: function(pixelNum, category, type, account) {
            //Check if category is NOT set, use default value
            if (category === undefined) {
                category = 'boost';
            }

            if (type === undefined) {
                type = 'boost671';
            }

            if (account === undefined) {
                account = '3717615';
            }

            bmToolkit.vars.pixel = pixelNum;
            var axel = Math.random() + "";
            var a = axel * 10000000000000;
            var floodlight = document.createElement('iframe');
            floodlight.src = '//' + account + '.fls.doubleclick.net/activityi;src=' + account + ';type=' + type + ';cat=' + category + pixelNum + ';ord=1;num=' + a + '?';
            floodlight.style.display = "none";
            floodlight.width = 1;
            floodlight.height = 1;
            floodlight.border = 0;

            bmToolkit.resources.store(floodlight);
        }, //end floodlightTag

        /**
         * Load the DOM element into an object. This lets us control when the DOM element gets loaded in the bmToolkit.resources.load method
         * @param {DOM Element} resource - This variable requires a DOM element NOT a string
         * @returns {none}
         */
        store: function(resource) {
            //Set a property to indicate whether or not this resources was loaded successfully
            resource.loaded = false;
            //Add to resources array
            bmToolkit.vars.resources.push(resource);
        }, //end bmToolkit.resources.store 

        /**
         * Loads assets into the resources object that will be used by every page load
         * Load all sitewide assets here
         * @returns {none}
         */
        all: function() {


            var brightcove = document.createElement('script');
            brightcove.type = 'text/javascript';
            brightcove.async = true;
            brightcove.src = '//s.btstatic.com/tag.js#site=lCgfimK';
            bmToolkit.resources.store(brightcove);

            var resource = document.createElement('script');
            resource.type = 'text/javascript';
            resource.async = true;
            resource.src = '//' + bmToolkit.vars.resourcesURL + '/foresee/foresee-trigger.js';
            bmToolkit.resources.store(resource);

            //Adobe DTM script
            var dtm = document.createElement('script');
            dtm.type = 'text/javascript';
            dtm.async = true;
            dtm.src = '//assets.adobedtm.com/058f84f4e7e71054c64df8cf68552abe037a02d8/satelliteLib-5061fba463dc51d188e5dfc6d60bc8fde062036c.js';
            //Adobe DTM needs a callback function. Wrapped in try catch in event of async execution issues
            dtm.onload = dtm.onreadystatechange = function() {
                try {
                    _satellite.pageBottom();
                }
                catch (err) {
                }
                dtm.onload = null;
                dtm.onreadystatechange = null;
            };
            bmToolkit.resources.store(dtm);

        }, //end bmToolkit.resources.all

        /**
         * Load assets from bmToolkit.vars.resources into the page
         * Loads scripts and CSS into the head and everything else into the body
         * Checks to make sure head/body are present before loading. If only head is available, will load scripts and loop recursively until body is available to finish inserting body content
         * Will only load assets once so this function can be called anytime a new resource has been added to load only the new resource. Useful for user generated events.
         * @returns {undefined}
         */
        load: function() {
            //Get/update the number of resources to be loaded
            bmToolkit.vars.resourcesTotal = helpers.countObjKeys(bmToolkit.vars.resources);
            //Loop through all items in the resources array
            for (var i = 0; i < bmToolkit.vars.resources.length; i++) {
                //Make sure this item hasn't already been loaded yet
                if (bmToolkit.vars.resources[i].loaded === false) {
                    //Check if this is a CSS or JS file and make sure head is loaded/not malformed
                    if (bmToolkit.vars.resources[i].type === 'text/javascript' || bmToolkit.vars.resources[i].type === 'text/css') {
                        //Load file into head
                        document.getElementsByTagName('head')[0].appendChild(bmToolkit.vars.resources[i]);
                        //Set this resouces loaded flag to true
                        bmToolkit.vars.resources[i].loaded = true;
                        //Now that this was successfully loaded, increment the resourcesLoaded var
                        bmToolkit.vars.resourcesLoaded++;
                        //Check if body is loaded    
                    } else if (document.body) {
                        //Load resource into body
                        document.body.appendChild(bmToolkit.vars.resources[i]);
                        //Set this resouces loaded flag to true
                        bmToolkit.vars.resources[i].loaded = true;
                        //Now that this was successfully loaded, increment the resourcesLoaded var
                        bmToolkit.vars.resourcesLoaded++;
                    }
                }
            }

            //Check if the # of successfully loaded resources equals the toal number of bmToolkit.resources. 
            //Make sure that we don't loop more than 25 times. This prevents indefinitely looping in the event of an error or unexpected behavior. This is about 5 seconds.
            if (bmToolkit.vars.resourcesLoaded !== bmToolkit.vars.resourcesTotal && bmToolkit.vars.loops < 25) {
                bmToolkit.vars.loops++;
                //If not, recursively call this function to keep trying until everything was successfully loaded
                setTimeout(function() {
                    bmToolkit.resources.load();
                }, 200);
            }

        }//end bmToolkit.resources.load
    };
    /************************************
     * Helper classes and methods. 
     ************************************/
    var helpers = {
        /**
         * Finds an item in an array
         * @param {array} array - Array to search
         * @param {type} needle - Value to look for in the supplied array
         * @returns {Int} - Returns the location in the array of the needle, -1 if not found
         */
        indexOf: function(array, needle) {
            //Check if the browser supports indexOf, older browsers do not
            if (typeof Array.prototype.indexOf === 'function') {
                return array.indexOf(needle);
                //IE8 and under do not support indexOf, use a loop for them instead
            } else {
                var i, index = -1;
                for (i = 0; i < array.length; i++) {
                    if (array[i] === needle) {
                        index = i;
                        return index;
                    }
                }
                return index;
            }
        }, //end indexof

        /**
         * Set a cookie
         * @param {string} name - Name of cookie
         * @param {string} value - Value of cookie
         * @param {int} days - Days to keep active
         * @param {string} path - (Optional) Path, should be /
         * @param {string} domain - (Optional) Domain to set cookie on
         * @param {string} secure - (Optional) Secure/non-secure
         * @returns {none}
         */
        setCookie: function(name, value, days, path, domain, secure) {
            bmToolkit.vars.cookies[name] = {
                'name': name,
                'value': value,
                'days': days,
                'path': path,
                'domain': domain,
                'secure': secure
            };
            //if no days are passed, make default 30 days
            var nNumDays = (days) ? days : 30;
            //convert to milliseconds
            nNumDays = nNumDays * 60 * 60 * 24 * 1000;
            //get today's date
            var dtExpires = new Date();
            //convert today's date to milliseconds and add number of days in milliseconds
            dtExpires.setTime(dtExpires.getTime() + nNumDays);
            //assign this mess to the new cookie
            document.cookie = name + "=" + escape(value) + ";expires=" + dtExpires.toUTCString() + ((path) ? ";path=" + path : ";path=/") + ((domain) ? ";domain=" + domain : "") + ((secure) ? ";secure" : "");
        }, //end setcookie

        /**
         * Count the number of items in an object and return the number
         * @param {type} object - Any JS object
         * @returns {Number} - Returns the number of items in the object
         */
        countObjKeys: function(object) {
            //Check if .length is supported
            if (Object.keys) {
                return Object.keys(object).length;
                //If not, count em manually. You suck IE8    
            } else {
                var count = 0;
                for (var k in object) {
                    if (object.hasOwnProperty(k)) {
                        ++count;
                    }
                }
                return count;
            }
        }
    };

    //Make sure this script only executes ONCE. We have some crappy vendors with bad code who load this script twice.
    if (!window.bmToolkit) {
        //Start the app
        bmToolkit.initialize();
    };
    
    //Expose the public methods and variables
    return bmToolkit;
})();
