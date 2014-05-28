
function bbSetServer() {

  var bs = require('bonescript');
  file = '/var/lib/cloud9/server.txt';
  bs.writeTextFile(file, document.location.host);

}

function bbGetServer(callback) {

  var bs = require('bonescript');
  file = '/var/lib/cloud9/server.txt';
  bs.readTextFile('/var/lib/cloud9/server.txt', callback);

}




function bbFileExists(filename, callback_yes, callback_no) {

  var b = require('bonescript');
  b.readTextFile('/var/lib/cloud9/autorun/forever.js', function(x) {

    if ((x.data != null) && (x.data.length != 0)) {
      callback_yes();
    } else {
      callback_no();
    }

  });

}

function bbRemoveFile(filename, callback_success) {

  var b = require('bonescript');
  b.writeTextFile(filename, "", callback_success);

}


function ScriptRemoveStatus(callback) {

  bbRemoveFile('/var/lib/cloud9/autorun/writestatus.js', function() {

    bbRemoveFile('/var/lib/cloud9/status.txt', callback);

  });

}


function ScriptRetrieveStatus(callback, mini) {

  console.log ("initating the status query...");
  if (mini == true ) { console.log ("only mini check..."); }

  var b = require('bonescript');

  var minitext = "";

  if (mini == true) { minitext = "var mini = true; " } else { minitext = "var mini = false; " }

  b.writeTextFile('/var/lib/cloud9/autorun/writestatus.js', minitext+'var b = require("bonescript"); '

    +'var ospackages = ["python-compiler", "python-misc", "python-multiprocessing", "python-distutils", "python-setuptools", "python-simplejson"];'

    +'var npmpackages = ["getmac", "serialport", "bonescript", "websocket", "dial-a-device-node"];'

    +'var status = { nodeversion: "unknown", ospackageinstallationstatus: "unknown", ospackagestatus: "unknown", ospackages: [], npmpackageinstallationstatus: "unknown", npmpackagestatus: "unknown", '
    
    +'dadinstallationstatus: "unknown", dadserver: "unknown", serverconnection: "unknown", internetconnection: "unknown" }; '


    +'function bbFileExists(filename, callback_yes, callback_no) {'
    +  'b.readTextFile(filename, function(x) {'
    +    'if ((x.data != null) && (x.data.length != 0) && (x.data != "")) {'
    +      'callback_yes();'
    +    '} else {'
    +      'callback_no();'
    +    '}'
    +  '});'
    +'}; '

    +'function checkOSPackageStatus(callback) {'

    + 'if (mini == true) { status.ospackagestatus = "not checked"; callback(); } else {'

    + 'var exec = require ("child_process").exec;'

    + 'function opkgify(p) { return "opkg status "+p };'
    +' var execstring = ospackages.map(opkgify).join(" && ");'
    + 'exec (execstring, '
    +   'function(error, stdout, stderr) { if ((stdout.indexOf("python-multiprocessing") > -1) && (stdout.indexOf("python-compiler") > -1) && (stdout.indexOf("python-misc") > -1) && (stdout.indexOf("python-distutils") > -1) && (stdout.indexOf("python-setuptools") > -1) && (stdout.indexOf("python-simplejson") > -1)) { status.ospackagestatus = "installed"; } else {status.ospackagestatus = "not installed";}; callback() } ); '

    + '};'

    + '}; '

    +'function checkNodeVersion(callback) {'

    + 'if (mini == true) { status.nodeversion = "not checked"; callback(); } else {'

    + 'var exec = require ("child_process").exec;'
    + 'exec ("node -v", '

      +'function(error, stdout, stderr) {  status.nodeversion = stdout.split("\\n")[0]; callback() } ); '

    + '};'

    + '}; '
    
    +'function checkNPMPackageStatus(callback) {'

    + 'if (mini == true) { status.npmpackagestatus = "not checked"; callback(); } else {'

    + 'var exec = require ("child_process").exec;'
    + 'exec ("npm list -g -parseable", '

      +'function(error, stdout, stderr) { if (stdout.indexOf("dial-a-device-node") > -1) { status.npmpackagestatus = "installed"; } else { status.npmpackagestatus = "not installed"; } callback() } ); '

    + '};'

    + '}; '
    
    +'function checkDADServer(callback) {'
    
    +  'b.readTextFile("/var/lib/cloud9/server.txt", function(x) {'
    +    'if ((x.data != null) && (x.data.length != 0)) {'
    +      'status.server = x.data; callback(); '
    +    '} else {'
    +      'status.server = x.data; callback(); '
    +    '}'
    +  '});'
    
    +'}'
    
    
    +'function checkDADStatus(callback) {'

    + 'if (mini == true) { status.dadinstallationstatus = "not checked"; callback(); } else {'
    
    +   'bbFileExists("/var/lib/cloud9/autorun/dial-a-device-node.js", function() { status.dadinstallationstatus = "installed"; checkDADServer(callback) }, function() { status.dadinstallationstatus = "not installed"; checkDADServer(callback) });'

    + '};'
        
    + '}; '

    +'function checkInternetconnection(callback) {'

    + 'if (mini == true) { status.internetconnection = "not checked"; callback(); } else {'

    + 'var exec = require ("child_process").exec;'
    + 'exec ("ping www.google.com -c 2", '

      +'function(error, stdout, stderr) { if (stdout.indexOf("2 received") > -1) { status.internetconnection = "connected"; } else { status.internetconnection = "not connected"; }; callback() } ); '

    + '}; '

    + '};'

    +'function checkServerconnection(callback) {'

    + 'if (mini == true) { status.internetconnection = "not checked"; callback(); } else {'

    + 'var exec = require ("child_process").exec;'
    + 'exec ("ping www.google.com -c 1", '

      +'function(error, stdout, stderr) { status.serverconnection = "connected"; callback() } ); '

    + '}; '

    + '};'


    +'function lastStep() {'

    + 'b.writeTextFile("/var/lib/cloud9/status.txt", JSON.stringify(status));'

    + 'b.writeTextFile("/var/lib/cloud9/autorun/writestatus.js", "");'

    +'}; '


    +'bbFileExists("/var/lib/cloud9/autorun/installospackages.js", function() { '
    
    +   'status.ospackageinstallationstatus = "installing"; mini = true; checkOSPackageStatus(function() { checkNodeVersion(function(){ bbFileExists("/var/lib/cloud9/autorun/installnpmpackages.js", function() {'
    
    +       'status.npmpackageinstallationstatus = "installing"; '

    +       'checkNPMPackageStatus(function() {checkDADStatus(function(){checkInternetconnection(function(){checkServerconnection(lastStep)})})}); '

    +   '}, function() {'
    
    +       'status.npmpackageinstallationstatus = "not installing"; '

    +       'checkNPMPackageStatus(function() {checkDADStatus(function(){checkInternetconnection(function(){checkServerconnection(lastStep)})})}); '
    
    +   '})})});'
    
    +'}, function() { '
    
    +   'status.ospackageinstallationstatus = "not installing"; checkOSPackageStatus(function() {checkNodeVersion(function(){ bbFileExists("/var/lib/cloud9/autorun/installnpmpackages.js", function() {'
    
    +       'status.npmpackageinstallationstatus = "installing"; mini = true;  checkNPMPackageStatus(function() {checkDADStatus(function(){checkInternetconnection(function(){checkServerconnection(lastStep)})})}); '

    +   '}, function() {'
    
    +       'status.npmpackageinstallationstatus = "not installing"; checkNPMPackageStatus(function() {checkDADStatus(function(){checkInternetconnection(function(){checkServerconnection(lastStep)})})}); '
    
    +   '})})});'
    
    +'});'


    , callback);

}

function ScriptReadStatus(callback_yes, callback_no) {

  console.log ("start read status");

  var b = require('bonescript');

  b.readTextFile('/var/lib/cloud9/status.txt', function (x) {

    if ((x.data != null) && (x.data.length != 0)) {

      callback_yes(JSON.parse(x.data));


    } else {

      callback_no();
    }

  });

}



var counter = 1;

var waitseconds = 60;

var global_status;

var checking = false;

var otheraction = false;

var installationaction = false;

var checktimer;


function cancel() {

  counter = 1;

  checking = false;

}


function checkInstallationStatus(what) {


  console.log ("checking installation status...");

  var b = require('bonescript');

  b.readTextFile ("/var/lib/cloud9/autorun/install"+what+"packages.js", function(x) {

      if ((x.data != null) && (x.data != "")) {

        is = setTimeout (function cs() {

          checkInstallationStatus(what);

        }, 5000);

        b.readTextFile ("/var/lib/cloud9/install"+what+"packages.log", function(y) {


          if (y.data != null) {
          var lines = y.data.split("\n");

          document.getElementById("installationlog").style.display = "";

          document.getElementById("installationlog").innerHTML = lines.slice(Math.max(lines.length - 5, 1)).join("<br>");

          } else {

            document.getElementById("installationlog").style.display = "";

            document.getElementById("installationlog").innerHTML = "waiting for log file...";

          }


        });

      } else {

        document.getElementById("installationlog").style.display = "none";

        checktimer = setTimeout (function cs() {

          checkStatus(what);

        }, 2000);

      } 

    });
  

}


function checkStatus() {

  document.getElementById("installationlog").style.display = "none";

  if (checking == false) {

    checking = true;

    counter = 1;

    var mini = false;


    if (otheraction == false) {

      setUIStatusCheckOngoing();

      
    }

    console.log ("checking status...");

      ScriptRemoveStatus(function() {


        ScriptRetrieveStatus(function() {

          checktimer = setTimeout (function cs() {

            checkAgainStatus();      

          }, 1000);

        }, installationaction);

       
      });

  }
 
}



function checkAgainStatus() {

  console.log ("waiting for status... " + counter);

  ScriptReadStatus(function (status) {

    try {

      console.log ("status received!");

      console.log (JSON.stringify(status));

      global_status = status;

      checking = false;

      otheraction = true;

      installationaction = false;

      if (status.ospackageinstallationstatus == "installing") {

        setUIInstallationOngoing();

            otheraction = true;

            installationaction = true;

            checkInstallationStatus("os");

      } else if (status.npmpackageinstallationstatus == "installing") {

        setUIInstallationOngoing();

            otheraction = true;

            installationaction = true;

            checkInstallationStatus("npm");
      } else if (status.ospackagestatus == "not installed") {

        if (status.internetconnection == "not connected") {

          setUIInternetconnectionNeeded();

          otheraction = true;

        } else {

          setUIOSInstallationNeeded();

        }

      } else if (status.npmpackagestatus == "not installed") {

        if (status.internetconnection == "not connected") {

          setUIInternetconnectionNeeded();

          otheraction = true;

        } else {

          setUINPMInstallationNeeded();

        }

      } else if (status.dadinstallationstatus == "not installed") {

        if (status.internetconnection == "not connected") {

          setUIInternetconnectionNeeded();

          otheraction = true;

        } else {

          setUIDADInstallationNeeded();

        }

      } else if (status.ospackagestatus == "installed" && status.npmpackagestatus == "installed" && status.dadinstallationstatus == "installed") {

        bbSetServer();

        setUISuccess();        

      } else {

        checkStatus();

      }

    } catch (e) {


    }

  }, function() {

    // no status yet

    if (counter < waitseconds) {

      counter = counter + 1;

      checktimer = setTimeout (function cs() {

          checkAgainStatus();      

        }, 1000);

    }

  })

  if (counter >= waitseconds) {

    console.log ("sorry, no status available.");

    clearTimeout(checktimer);

    checking = false;

    checkStatus();

  }

}


function setUISuccess() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/greencheck.png' >&nbsp;Dial-a-device is installed on this BeagleBone.&nbsp;"+ "<button onclick='uninstall()' class='btn btn-danger'>Uninstall</button>";

  document.getElementById("submitbutton").className = "btn btn-success";

}

function setUIFailed() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/error.png' >&nbsp;Check failed.&nbsp;"+ "<button onclick='checkStatus()' class='btn btn-warning'>Check again</button>";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}

function setUIStatusCheckOngoing() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/ajax-violet.gif' >&nbsp;Checking installation status, please wait...&nbsp;";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}

function setUIInstallationOngoing() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/ajax-violet.gif' >&nbsp;The installation is ongoing...";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}

function setUIOSInstallationNeeded() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/error.png' >&nbsp;OS Packages need to be installed on this BeagleBone.&nbsp;"+ "<button onclick='install(\"os\")' class='btn btn-success'>Install OS packages</button>";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}

function setUINPMInstallationNeeded() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/error.png' >&nbsp;NPM packages need to be installed on this BeagleBone.&nbsp;"+ "<button onclick='install(\"npm\")' class='btn btn-success'>Install NPM packages</button>";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}

function setUIDADInstallationNeeded() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/error.png' >&nbsp;Dial-a-device needs to be installed on this BeagleBone.&nbsp;"+ "<button onclick='install(\"dad\")' class='btn btn-success'>Install</button>";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}




function setUIInternetconnectionNeeded() {

  document.getElementById("install-status").innerHTML = "<img src='/assets/error.png' >&nbsp;The BeagleBone needs to be connected to the internet via ethernet cable to install required packages.&nbsp;"+ "<button onclick='checkStatus()' class='btn btn-warning'>Check again</button>";

  document.getElementById("submitbutton").className = "btn btn-success disabled";

}


function uninstall() {

  console.log ("uninstall");

  var b = require('bonescript');

    file = '/var/lib/cloud9/autorun/dial-a-device-node.js';
    b.writeTextFile(file, "", function(x) {

      otheraction = false;

      file = '/var/lib/cloud9/autorun/removenpmpackages.js';
      b.writeTextFile(file, "var exec = require ('child_process').exec; exec ('rm /var/lib/cloud9/autorun/dial-a-device-node.js; npm remove -g dial-a-device-node &> /var/lib/cloud9/installnpmpackages.log; rm /var/lib/cloud9/autorun/removenpmpackages.js', function(error, stdout, stderr) {console.log (stdout)});", function(x) {

        console.log (x);
        checkStatus();


      });


    });


}

function install(what) {

  var status = global_status;

  if (what == "os") {

    // install ospackages

    installationaction = true;

    console.log ("install os packages");

    var b = require('bonescript');

    file = '/var/lib/cloud9/autorun/installospackages.js';
    b.writeTextFile(file, "var exec = require ('child_process').exec; exec ('rm /var/lib/cloud9/installospackages.log; echo -n \"installing\" > /var/lib/cloud9/installospackages.status; opkg update && opkg install python-compiler && opkg install python-misc && opkg install python-multiprocessing && opkg install python-distutils && opkg install python-setuptools && opkg install python-simplejson &> /var/lib/cloud9/installospackages.log; rm /var/lib/cloud9/autorun/installospackages.js; echo -n \"completed\" > /var/lib/cloud9/installospackages.status', function(error, stdout, stderr) {console.log (stdout)});", function(x) {

      otheraction = true;
      setUIInstallationOngoing();

      checkInstallationStatus(what);


    });

  } else if (what == "npm") {

    // install npmpackages

    installationaction = true;

    setUIInstallationOngoing();
    

    // install dad in autorun

    var b = require('bonescript');

      otheraction = true;

      

      file = '/var/lib/cloud9/autorun/installnpmpackages.js';
      b.writeTextFile(file, "var exec = require ('child_process').exec; exec ('rm /var/lib/cloud9/installnpmpackages.log; echo -n \"installing\" > /var/lib/cloud9/installnpmpackages.status; npm update &> /var/lib/cloud9/installnpmpackages.log; npm install -g getmac && npm install -g serialport && npm install -g coffee-script && npm install -g websocket && npm install -g dial-a-device-node &> /var/lib/cloud9/installnpmpackages.log; rm /var/lib/cloud9/autorun/installnpmpackages.js; echo -n \"completed\" > /var/lib/cloud9/installnpmpackages.status', function(error, stdout, stderr) {console.log (stdout)});", function(x) {

        otheraction = true;

        setUIInstallationOngoing();

        checkInstallationStatus(what);

      });



  } else if (what == "dad") {

    bbSetServer();

    var b = require('bonescript');

    file = '/var/lib/cloud9/autorun/dial-a-device-node.js';
    b.writeTextFile(file, "var b = require('bonescript'); var dialadevicenode = require ('dial-a-device-node'); b.readTextFile('/var/lib/cloud9/server.txt', function(x) { if ((x.data != null) && (x.data.length != 0)) { dialadevicenode.run_beaglebone(x.data); } });", function(x) {

      setUIInstallationOngoing();
      
      checkStatus();

    });  

  } 

}
