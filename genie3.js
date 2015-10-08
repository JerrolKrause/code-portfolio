/**
 * Phone genie class object 
 * REQUIRES jQuery jCarousel AND jQuery qTip
 * @returns {undefined}
 */
window.bmPhoneGenie = (function() {    
    'use strict';
    
    //Public object/vars
    var bmPhoneGenie = {};
    var params = {
        phones : $('#genie3-ul li.tile')
    };
    
    
    /**
     * Start everything
     * @returns {undefined}
     */
    bmPhoneGenie.load = function(){
        //Start dropdowns and plugins
        dropdown.countPhones();
        plugins();
        
        //When the dropdown menu is changed, sort or filter the genie
        $('#phone-order').on('change', function() {
            dropdown.behavior($(this).find('option:selected'));
        });
        
        //Add tracking links
        params.phones.find('a').on('mouseover',function(){
            addTracking($(this));
        });
    };//end load
    
    
    /**
     * Launch plugin logic used by the genie
     * @returns {undefined}
     */
    var plugins = function() {
        
        //Start the carousel
        params.carousel = $('#genie3-phones').jcarousel({
            animation: 300,
            wrap: 'both'
        });
        
        //Add Carousel Controls
        $('.jcarousel-control-prev').jcarouselControl({target: '-=3'});
        $('.jcarousel-control-next').jcarouselControl({target: '+=3'});

        //Manages the qtip2 plugin needed for the modal window
        params.phones.each(function() {
            $(this).qtip({
                content: {
                    text: $(this).find('.genie3-modal'),
                    button: true
                },
                hide: {
                    fixed: true,
                    delay: 300,
                    effect: function() {
                        $(this).fadeOut(100);
                    }
                },
                show: {
                    event: 'click',
                    effect: function() {
                        $(this).fadeTo(200, 1);
                    }
                },
                position: {
                    my: 'bottom left', // Position my top left...
                    at: 'left center',
                    target: $(this),
                    adjust: {
                        method: 'flip none',
                        x: 30
                    },
                    viewport: $(window)
                }
            });
        });
    };//end plugins
    
    
    /**
     * Functionality for the genie dropdown
     */
    var dropdown = {
        
        /**
         * Determines which behavior to use for each option of the genie dropdown. Necessary because there are various combinations of sorting and filtering
         * @param {type} option - The jquery object of the option selected
         * @returns {undefined}
         */
        behavior : function(option){
            
            //Add all the phones back into the genie
            params.phones.appendTo('#genie3-ul');

            //Default sort order and show all phones
            if (option.attr('id') === 'position') {
                dropdown.sort(option.val(), option.data('sort'));
            //Only show last 6 months of phones and sort by launch date    
            } else if (option.attr('id') === 'date-launch') {
                params.phones.filter(function() {
                    return $(this).data('date-launch') < params.lastDate;
                }).detach();
                dropdown.sort(option.val(), option.data('sort'));
            //Only show phones with 4 stars or up and sort by highest to lowest    
            } else if (option.attr('id') === 'rating') {
                //Remove all phones under rating 4
                params.phones.filter(function() {
                    return $(this).data('rating') < 4;
                }).detach();
                dropdown.sort(option.val(), option.data('sort'));
            //Only show CPO phones
            } else if (option.attr('id') === 'cpo') {
                //Remove all the new phones
                params.phones.filter('.condition-new').detach();
            //Only show best sellers
            } else if (option.attr('id') === 'best-seller') {
                params.phones.not('[data-best-seller]').detach();
                dropdown.sort(option.val(), option.data('sort'));
            } 
            
            //Reload the carousel now
            params.carousel.jcarousel('reload');
            //Jump to the first item in the list and do so without scrolling
            params.carousel.jcarousel('scroll', 0);
        },//end behavior
       
        /**
         * Sort the array of visible phones
         * @param {type} attr - The attribute to sort for on the phone tile
         * @param {type} sortType - Ascending or descending
         * @returns {undefined}
         */
        sort : function(attr, sortType){
            params.phones.filter(':visible').sort(function(a, b) {
                //Figure out sorting options
                if (sortType === 'asc') {
                    return ($(a).attr(attr)) - ($(b).attr(attr));
                } else {
                    return ($(b).attr(attr)) - ($(a).attr(attr));
                }
            }).appendTo('#genie3-ul');
        }, //end sort
        
        /**
         * Updates the dropdown menu with a numeric count of the number of phones
         * @returns {undefined}
         */
        countPhones: function() {
            var rating = 0, recent = 0, bestseller = 0;

            //Date manipulation to get datetime of 6 months ago
            var dateString = $('#genie3-phones').data('datetime').toString();
            var currentDate = new Date(dateString.substring(0, 4), dateString.substring(4, 6) - 1, dateString.substring(6, 8));
            currentDate.setMonth(currentDate.getMonth() - 6);
            params.lastDate = currentDate.getFullYear().toString() + ('0' + (currentDate.getMonth() + 1)).slice(-2) + ('0' + currentDate.getDate()).slice(-2); //Store variable for use in another method

            //Loop through all phones, perform calculations once
            $.each(params.phones, function() {
                if ($(this).data('rating') >= 4) {
                    rating++;
                }
                if ($(this).data('date-launch') >= params.lastDate) {
                    recent++;
                }
                if ($(this).data('best-seller')) {
                    bestseller++;
                }
            });
            
            //Update labels with phones listed
            $('#cpo').text($('#cpo').text() + ' (' + $('.condition-cpo').length + ')');
            $('#rating').text($('#rating').text() + ' (' + rating + ')');
            $('#date-launch').text($('#date-launch').text() + ' (' + recent + ')');
            $('#best-seller').text($('#best-seller').text() + ' (' + bestseller + ')');
        }//end countPhones
    };//end dropdown
   
   
    /**
     * Appends tracking code to the URL
     * @param {type} link The jquery object of the link being clicked
     * @returns {undefined}
     */
    var addTracking = function(link){
        //Figure out which variation of the site we are on
        var lang = 'HP';
        if (window.Modernizr.user === 'customer' && window.urlParams.lang !== 'esp') {
            lang = 'CHP';
        } else if ((window.location.host === 'espanol.boostmobile.com' || window.urlParams.lang === 'esp') && window.Modernizr.user === 'visitor') {
            lang = 'SHP';
        } else if ((window.location.host === 'espanol.boostmobile.com' || window.urlParams.lang === 'esp') && window.Modernizr.user === 'customer') {
            lang = 'SCHP';
        } 
        
        //Get page ID from the body tag
        var pageID = $('body').attr('class').split(' ').slice(-1)[0].replace('page-', '');
        
        //Update the link
        link.attr('href',function(){
            return $(link).attr('href').split('?')[0] + '?icamp=INTC_'+pageID+lang+'_'+'GENIE_'+$('#phone-order option:selected').val()+'_'+$(this).data('phone');
        });
    };//End addTracking 
    
    
    //Launch the application 
    try {
      bmPhoneGenie.load();
    //Catch errors within this app to interfering with JS on the host page
    } catch (err) {
        params.errors.push(err);
    }

    //Make private properties available to the API with prefix
    bmPhoneGenie._params = params;
    //Make API public
    return bmPhoneGenie;
})();