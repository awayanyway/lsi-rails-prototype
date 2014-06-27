

function dual_mouse_zoom(container,container2, data, op) {

    var options, options2, options3, graph, graph2, graph3, selec, i, x0, y0;
 
     
    options = Flotr._.extend({
    	                      selection: { mode: 'xy',
                                           fps: 30,
                                           }, 
                              HtmlText: false,
                              },       op);
   
    options2 = {   
    		selection: { mode: 'x',
                fps: 30
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
            },
            
        };

    options.title = null;
    // Draw graph with default options, overwriting with passed options
     
    i=data[0];
    x0 = i[0];
    y0= i[1];
    function drawGraph(opts) {

        // Clone the options, so the 'options' variable always keeps intact.
        var o = Flotr._.extend(Flotr._.clone(options), opts || {});

        // Return a new graph.
        return Flotr.draw(
        container, [data], o);
    }
    
    function drawGraph2(sel) {
    
     var  s = sel || [x0, y0, x0, y0],
       x1 = s[0] ,
       y1 = s[1] ,
       x2 = s[2] ,
       y2 = s[3] ,
       xw =  x2 - x1,
       yw = y2 - y1 ,
       d = [x1, y1, xw, yw];
//  o = Flotr._.extend(Flotr._.clone(options2), {title: ''});
    	// Return a new graph.
        return Flotr.draw(container2, [  {data: data,revlines: {show: true }}, {data: [d], rectangle: {show: true}}], options2);
    }
    

  
    // Actually draw the graph.
    graph  = drawGraph({margin: false,
 
                     });
    graph2 = drawGraph2();
//    graph3 = drawGraph3();
    // Hook into the 'flotr:select' event.
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


function dual_mouse_zoom2(container,container2, data, op, chips) {

    var options, options2, options3, graph, graph2, graph3, selec, i, x0, y0,temp;

    options = Flotr._.extend({selection: { mode: 'xy',
                                           fps: 30
                                          }, 
                              HtmlText: false,
                              spreadsheetJdx: { show: true,
                                              tickFormatter: function(e) {return e + '';},
                                             },
                              }
                             , op);
    //options.spreadsheetJdx.ldrS = {};
    options2 = {   
            selection: { mode: 'x',
                fps: 30
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

    options.title = null;
    // Draw graph with default options, overwriting with passed options
     
    i=data[0];
    x0 = i[0];
    y0= i[1];
    

    
    function drawGraph(opts) {

        // Clone the options, so the 'options' variable always keeps intact.
     var    o = Flotr._.extend(Flotr._.clone(options), opts || {}),
          dat = data,
          url =  '/datasets/munch',
       ajdata = {r0: o.xaxis.min ,r1: o.xaxis.max ,block:  chips.block, page: chips.page, dataset_id: chips.datasetid}  ,
   getnewdata = $.ajax({ type: "POST", url: url,  data: ajdata   });
                  
         getnewdata.fail(function(jqXHR, textStatus){ 
                           if (jqXHR.status === 0)    {   alert('Not connect.\n Verify Network.');    }
                      else if (jqXHR.status == 404)   {   alert('Requested page not found. [404]');   }
                      else if (jqXHR.status == 500)   {  
                          // alert('Internal Server Error [500].');  
                               }
                      else if (exception === 'parsererror') {alert('Requested JSON parse failed.'); }
                      else if (exception === 'timeout')    {   alert('Time out error.'); }
                      else if (exception === 'abort')  {  alert('Ajax request aborted.');  }
                      else   {    alert('Uncaught Error.\n' + jqXHR.responseText);  } 
                      });
         
         Flotr.draw( container, [dat], o);
         
         $.when(getnewdata).done(function(data, textStatus, jqXHR){
                        temp =  jqXHR.responseJSON;
                        if (jQuery.isEmptyObject(temp)){} else{
                        Flotr.draw( container, temp, o)};
                         });
           
         // Return a new graph.
       // return  Flotr.draw( container, [dat], o);
    }
    
    function drawGraph2(sel) {
    
     var  s = sel || [x0, y0, x0, y0],
       x1 = s[0] ,
       y1 = s[1] ,
       x2 = s[2] ,
       y2 = s[3] ,
       xw =  x2 - x1,
       yw = y2 - y1 ,
       d = [x1, y1, xw, yw];
//  o = Flotr._.extend(Flotr._.clone(options2), {title: ''});
        // Return a new graph.
        return Flotr.draw(container2, [  {data: data,revlines: {show: true }}, {data: [d], rectangle: {show: true}}], options2);
    }
   
    // Actually draw the graph.
    graph  = drawGraph({margin: false});
    graph2 = drawGraph2();
    //    graph3 = drawGraph3();
    // Hook into the 'flotr:select' event.
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

