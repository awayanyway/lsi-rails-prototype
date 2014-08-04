

function dual_mouse_zoom2(container,container2, data, op, chips) {

    var options, options2, options3, graph, graph2, graph3, selec, i0, i8, x0, x8, y0, y8,temp, light = false, 
    	graphWindow= [],
    	gc = chips.graphclass,
    	start;  // drag event initial position

    var
	  D = Flotr.DOM,
	  _ = Flotr._;

    Flotr.addPlugin('mouseTools', {
      
//          	options: {
//          	    show: true, 
//          	},
          	
          	callbacks: {
          		    'flotr:afterinit': function() {
          		      this.mouseTools.showToolbar();
          		    },		   
          		  },
          	
          	showToolbar: function(){
          		if(!this.options.mouseTools.show)
          		      return;
          		//var buttonZoomYd2, buttonXUnit, buttonDrag,
          		var        t;
          		var toolbar = D.node('<div class="flotr-datagrid-toolbar" style="position:absolute;left:0px;width:'
          		                      +this.canvasWidth+'px"></div>'),

          		  	buttonZoomYd2 = D.node(
          	    					'<button type="button" class="flotr-datagrid-toolbar-button">' +
          	      					'Y/2' +
       		      					'</button>'),
       			    buttonXUnit = 	D.node(
       						    	'<button type="button" class="flotr-datagrid-toolbar-button">' +
       		   						'x Unit'+
									'</button>'),
          		    buttonDrag = 	D.node(
       		      					'<button id="buttonDrag" type="button" class="flotr-datagrid-toolbar-button">' +
          		      				'Drag'+
          		      				'</button>'),
					offset = D.size( buttonZoomYd2).height + 4;
          	      
          	      D.setStyles(toolbar, {top: this.canvasHeight-offset+'px'});
         		    this.
         		    	observe(buttonZoomYd2, 'click', zoomYd2);
            	   // this.observe(buttonDrag,   'contextmenu', initializeDrag);
 				//Flotr.EventAdapter.observe(buttonDrag , 'flotr:mousedown', initializeDrag);
          		  D.insert(toolbar, buttonZoomYd2);
           		  D.insert(toolbar, buttonXUnit);
          		  D.insert(toolbar, buttonDrag);
          		  D.insert(this.el, toolbar);
        		  },  
//          		  
          });

    options = _.extend({selection: { mode: 'xy',
                                           fps: 30,
                                          }, 
                              HtmlText: false,
                              mouse: {
                                  track: true,
                              },
                      
                              mouseTools: {
                            	  show: false,
                            	  
                              },
                              spreadsheetJdx: { show: true,
                                              tickFormatter: function(e) {return e + '';},
                                             },
                              }
                             , op);
    //options.spreadsheetJdx.ldrS = {};
    options2 = {   
             selection: { mode: 'x',
                 fps: 30,
                }, 
            title: options.title,
            xaxis: {
            showLabels: false,
            margin: false,
            autoscale: false ,
            directionReversed: options.xaxis.directionReversed,
            },
            yaxis: {
            showLabels: false,
            margin: false,
            autoscale: true ,
            }
        };
    
    if (gc == 'PEAKTABLE') {
    	   options.bars = {show: true,
//                         horizontal: horizontal,
//                         shadowSize: 0,
                           barWidth: 0.1,
                           }; }

    options.title = null;
    options.spreadsheetJdx.reference = []; 
    options.spreadsheetJdx.checkstate = [];
    // Draw graph with default options, overwriting with passed options
     
    i0 = data[0];
    x0 = i0[0];
    y0 = i0[1];
    // i8 = data[data.length-1];
    // x8 = i8[0];
    // y8 = i8[1];
    
	function validatecheck(){
    	var sel,st;
         sel=$(".dataselect");
    	 _.each(sel, function( element,index) {st.push(element.checked);});
          return st;
    }
    
	function refere(ar,ar2,o){
	   var r = [],
	       arr =  ar ,
           arr2 = ar2  ;
	   
	  if  (jQuery.isEmptyObject(arr)) {arr  = o.spreadsheetJdx.reference ;}
	  if  (jQuery.isEmptyObject(arr2)){arr2 = o.spreadsheetJdx.checkstate ;}
	  if (arr.length > 0 && arr.length == arr2.length) {
		                                                  _.each(arr,function(element,index) {if (arr2[index]) {r.push(element.split(","));}});
		   												} 
	   return r;
   	} 	

       
   
    function drawGraph(opts) {
        // Clone the options, so the 'options' variable always keeps intact.
       var o   = _.extend(_.clone(options), opts || {}),
           dat = data,
           url =  '/datasets/munch',
           //sel =  $(".dataselect"),
           sel = document.getElementsByClassName('dataselect'),
           ref= _.map(sel,function( element,index) {return element.id;     }),
           st = _.map(sel,function( element,index) {return element.checked;}),
           bl =  chips.block ,
           pa =  chips.page,
           did=  chips.datasetid,
           refe =  refere(ref,st,o),
           getnewdata,
           ajdata     = {r0: o.xaxis.min ,r1: o.xaxis.max ,block:  bl, page: pa, dataset_id: did, ref: refe}  ;
           //getnewdata = $.ajax({ type: "POST", url: url,  data: ajdata   });         
       
       
      if (sel.length > 0 ) {o.spreadsheetJdx.checkstate=st;
                            o.spreadsheetJdx.reference=ref;}
      
      
      
        
          Flotr.draw( container, [dat], o);
     //  if (o.light === true ){} else {
       	getnewdata = $.ajax({ type: "POST", url: url,  data: ajdata   });
       	 getnewdata.fail(function(jqXHR, textStatus){ 
                           if (jqXHR.status === 0)    {   alert('Not connected.\n Verify Network.');    }
                      else if (jqXHR.status == 404)   {   alert('Requested page not found. [404]');   }
                      else if (jqXHR.status == 500)   {  
                          // alert('Internal Server Error [500].');  
                               }
                      else if (exception === 'parsererror') {alert('Requested JSON parse failed.'); }
                      else if (exception === 'timeout')    {   alert('Time out error.'); }
                      else if (exception === 'abort')  {  alert('Ajax request aborted.');  }
                      else   {    alert('Uncaught Error.\n' + jqXHR.responseText);  } 
                      });
         $.when(getnewdata).done(function(data, textStatus, jqXHR){
                        temp =  jqXHR.responseJSON;
                      
                        if (jQuery.isEmptyObject(temp)){ 
                        	return Flotr.draw( container, [dat], o);
                        } else{
                      	 return Flotr.draw( container, temp, o);};                              
         }); 
	//}
         //graphWindow=this.axes.x     
         // Return a new graph.
       // return  Flotr.draw( container, [dat], o);
    }
    
    function drawGraph2(sel) {
    
       var  s = sel || [x0, y0, x0, y0],
           x1 = s[0] ,
           y1 = s[1] ,
           x2 = s[2] ,
           y2 = s[3] ,
           xw =  x2 - x1 ,
           yw =  y2 - y1 ,
            d = [x1, y1, xw, yw];
  //  o = _.extend(_.clone(options2), {title: ''});
          // Return a new graph.
       graphWindow = sel;
       if (gc == 'PEAKTABLE') {return Flotr.draw(container2, [  {data: data,bars: { show: true,
    	   						              		   			             		barWidth: 0.1},},
                                                                {data: [d], rectangle: {show: true}}], options2);   
       }                 else {return Flotr.draw(container2, [  {data: data,lines: {show: true ,
    	   																			}},
                                                                {data: [d], rectangle: {show: true}}], options2);
       }
    }
    
    graph  = drawGraph({margin: false});
    
    graph2 = drawGraph2();

    
	function zoomYd2(){
    	var xmin=  graph2.axes.x.min,
    	    xmax=  graph2.axes.x.max,
    	    ymin= graph2.axes.y.min,
    	    ymax= graph2.axes.y.max,
    		s  = graphWindow  || [xmin, ymin,xmax,ymax ], //|| [x0, y0, x0, y0],
    	   d  = (s[3]-s[1]) ;
    	
    	s= [s[0],s[1],s[2],s[3]+d];
    	
    	graph = drawGraph({
							margin: false,
             				xaxis: {
                 					min: s[0],
                 					max: s[2],
                 					title: op.xaxis.title,
                 					directionReversed: options.xaxis.directionReversed,
                 					},
             				yaxis: {
                 					min: s[1],
                 					max: s[3],
                 					title: op.yaxis.title,
             						}
         					});
         graph2 = drawGraph2(s);
	}
    
   

	
 ////////////////////////////////
  // function mouse_drag(container) {
/*
    function initializeDrag(e) {
        
        start = graph2.getEventPosition(e);
       light = true;
        Flotr.EventAdapter.observe(document, 'mousemove', move);
        light = false;
        Flotr.EventAdapter.observe(document, 'mouseup', stopDrag);
    }

    function move(e) {
        var 
      		end = graph2.getEventPosition(e), 
            offset = {	x:  start.x - end.x,
        				y:  start.y - end.y
        				};
        if( options.xaxis.directionReversed) {offset.x *=-1;} else {}
      	var	xmin=  graph2.axes.x.min,
    	    xmax=  graph2.axes.x.max,
    	    ymin= graph2.axes.y.min ,
    	    ymax= graph2.axes.y.max ,
    		s  = graphWindow  || [xmin, ymin,xmax,ymax ]; 
 	  
    	graph = drawGraph({
							margin: false,
             				xaxis: {
                 					min: s[0]+offset.x,
                 					max: s[2]+offset.x,
                 					title: op.xaxis.title,
                 					directionReversed: options.xaxis.directionReversed,
                 					},
             				yaxis: {
                 					min: s[1]+offset.y,
                 					max: s[3]+offset.y,
                 					title: op.yaxis.title,
             					},
             				light: light,		
         					});
         if (light === false) {graph2 = drawGraph2(s); }
      
       
        // @todo: refector initEvents in order not to remove other observed events
      //  Flotr.EventAdapter.observe(graph.overlay, 'flotr:mousedown', initializeDrag);
    }

    function stopDrag() {
    	//alert(start.x);
    	light = false;
        Flotr.EventAdapter.stopObserving(document, 'mousemove', move);
    }  
*/
//})(document.getElementById("editor-render-0"));
//////////////////////////////////////////

  
  //Flotr.EventAdapter.observe(graph2.overlay, 'mousedown', initializeDrag);  
   
  Flotr.EventAdapter.observe(container, 'flotr:select', function(area) {
         
        // Draw graph with new area
        graph = drawGraph({
            margin: false,
            xaxis: {
                min: area.x1,
                max: area.x2,
                title: op.xaxis.title,
                directionReversed: options.xaxis.directionReversed,
                },
            yaxis: {
                min: area.y1,
                max: area.y2,
                title: op.yaxis.title,
            }
        });
        graph2 = drawGraph2([area.x1, area.y1, area.x2, area.y2]);
    });
   
  
   Flotr.EventAdapter.observe(container2, 'flotr:select', function(area) {
        
        
        // Draw graph with new area
        graph = drawGraph({
            margin: false,
            xaxis: {
                min: area.x1,
                max: area.x2,
                title: op.xaxis.title,
                directionReversed: options.xaxis.directionReversed
            },
            yaxis: {
                min: area.y1,
                max: area.y2,
                title: op.yaxis.title
            }
        });
        graph2 = drawGraph2([area.x1, area.y1, area.x2, area.y2]);
    });

    // When graph is clicked, draw the graph with default area.
    Flotr.EventAdapter.observe(container, 'flotr:click', function() {
        drawGraph();
        drawGraph2();
        
    });
     Flotr.EventAdapter.observe(container2, 'flotr:click', function() {
         drawGraph();
         drawGraph2();
     });
    
};

