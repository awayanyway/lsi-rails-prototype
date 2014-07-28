function smartinput (div_id, callbackfn, caption) {

        var smartinputdiv = document.getElementById (div_id);

        var smartinputfield_id = div_id + "_input";

        var smartinputinc_id = div_id + "_inc";

        var smartinputdec_id = div_id + "_dec";


        smartinputdiv.innerHTML = '<div class="input-group"><span class="input-group-addon">'+caption+'</span><input id="'+ smartinputfield_id +'" type="text" class="form-control"><span class="input-group-btn"><button class="btn" type="button" id="'+ smartinputinc_id +'"><span class="glyphicon glyphicon-plus"></span></button></span><span class="input-group-btn"><button class="btn" type="button" id="'+ smartinputdec_id +'"><span class="glyphicon glyphicon-minus"></span></button></span>';


        smartinputdiv.className += " input-append";

        var smartinputfield = document.getElementById (smartinputfield_id);

        var smartinputinc = document.getElementById (smartinputinc_id);

        var smartinputdec = document.getElementById (smartinputdec_id);

        var refreshIntervalId;

        var waitaftertypingTimer;

        var callcount = 0;

        var interval = 0;

        var intervalactive = false;

        var doneTypingInterval = 3000;

        function submitchangeval (val) {

            if (val != 0) {

                currentval = parseInt(smartinputfield.value);

                newval = currentval + val;

                smartinputfield.value = newval;

            }

            clearTimeout(waitaftertypingTimer);

            waitaftertypingTimer = setTimeout(function(){

                clearTimeout(waitaftertypingTimer);

                $("#"+smartinputfield_id).removeClass ("dontupdate");
                smartinputfield.blur();

                callbackfn (newval);

            }, doneTypingInterval);

            
        }

        $('#'+smartinputfield_id).keyup(function(){


            submitchangeval(0);

        });

        $("#"+smartinputfield_id).keypress(function(e) {
            //13 maps to the enter key
            if (e.keyCode == 13) {

                e.preventDefault();

                submitchangeval(0);
                smartinputfield.blur();
                callbackfn (newval);
            }

            $("#"+smartinputfield_id).addClass ("dontupdate");
        });

        $("#"+smartinputfield_id).focusin(function() {

            $("#"+smartinputfield_id).addClass ("dontupdate");
        });

        document.getElementById(smartinputfield_id).onblur = function() {

          clearTimeout(waitaftertypingTimer);

          submitchangeval(0);

        };

        

        $("#"+smartinputinc_id).click(function() {

            intervalactive = false;

            clearInterval (refreshIntervalId);

            submitchangeval(1);
        });

        $("#"+smartinputdec_id).click(function() {

            intervalactive = false;

            clearInterval (refreshIntervalId);

            submitchangeval(-1);
        });


        $("#"+smartinputinc_id).mouseup(function() {

            intervalactive = false;

            clearInterval (refreshIntervalId);

            callcount = 0;
        });

        $("#"+smartinputdec_id).mouseup(function() {

            intervalactive = false;

            clearInterval (refreshIntervalId);

            callcount = 0;
        });


        $("#"+smartinputinc_id).mousedown(function() {

            intervalactive = true;

            $("#"+smartinputfield_id).addClass ("dontupdate");

            refreshIntervalId = setInterval(function(){

                if (intervalactive) {

                    callcount += 1;

                    if(callcount<6 )
                    {
                        interval = 1;
                    }

                    if(callcount>=6 && callcount <10 )
                    {
                        interval = 5;
                    }

                    if(callcount>=10)
                    {
                        interval = 10;
                    }


                    submitchangeval (interval);

                }

            }, 500);

        });

        $("#"+smartinputdec_id).mousedown(function() {

            intervalactive = true;

            $("#"+smartinputfield_id).addClass ("dontupdate");

            refreshIntervalId = setInterval(function(){

                if (intervalactive) {

                    callcount += 1;

                    if(callcount<6 )
                    {
                        interval = -1;
                    }

                    if(callcount>=6 && callcount <10 )
                    {
                        interval = -5;
                    }

                    if(callcount>=10)
                    {
                        interval = -10;
                    }

                    submitchangeval (interval);

                }

            }, 500);

        });


};