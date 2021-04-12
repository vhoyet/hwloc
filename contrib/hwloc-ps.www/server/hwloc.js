const app = require('express')();
const http = require('http').createServer(app);
const io = require('socket.io')(http);
const path = require('path')
const { exec } = require("child_process");
const version = "1.0.0";
var HPPORT = 3000;

function usage() {
  console.log(path.basename(process.argv[0]) + " " + path.basename(process.argv[1]) + " [options]");
  console.log("Options:");
  console.log("  --hp <port>   Change hwloc-ps JSON server port (default is "+HPPORT+")");
  console.log("  -h --help     Show this help");
}

var currentarg = 2;
while(process.argv.length > currentarg) {
  if(process.argv[currentarg] === '-h' || process.argv[currentarg] === '-help') {
    usage();
    return;
  } else if (process.argv[currentarg] === '--hp') {
	  if(currentarg+2 > process.argv.length) {
	    console.err("Missing argument after --hp");
	    usage();
	    return;
	  }
	  HPPORT = process.argv[currentarg + 1];
	  currentarg += 2;
  }
	currentarg++;
}

io.on('connection', ( socket ) => {
  socket.on('check-version', ( msg ) => {
      
    socket.emit('check-version', version);
    
  });

  socket.on('get_xml', ( msg ) => {
    exec('../../../utils/lstopo/lstopo --of xml', ( error, stdout, stderr ) => {

      if (error) {
        console.log(`error: ${error.message}`);
        return;
      }
      if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
      }
      
      socket.emit('set_xml', stdout);
    });
    
  });

  socket.on('get_svg', ( msg ) => {
    exec('../../../utils/lstopo/lstopo --of nativesvg', ( error, stdout, stderr ) => {

      if ( error ) {
        console.log(`error: ${error.message}`);
        return;
      }
      if ( stderr ) {
        console.log(`stderr: ${stderr}`);
        return;
      }

      socket.emit('set_svg', stdout);
    });
    
  });

  socket.on('hwloc-ps', ( msg, reload ) => {
    exec('../../../utils/hwloc/hwloc-ps ' + msg, ( error, stdout, stderr ) => {

      if ( error ) {
        console.log(`error: ${error.message}`);
        return;
      }

      if ( stderr ) {
        console.log(`stderr: ${stderr}`);
        return;
      }
      
      socket.emit('hwloc-ps', buildProcessesObject(stdout), reload);
    });
  });

  socket.on('hwloc-bind', function ( pid, runner, callback ) {
    exec('../../../utils/hwloc/hwloc-bind --pid ' + pid + ' ' + runner, ( error, stdout, stderr ) => {

      if ( error ) {
        console.log(`error: ${error.message}`);
        socket.emit('hwloc-bind', 'failed');
        callback(error, null);
      }

      if ( stderr ) {
        socket.emit('hwloc-bind', 'failed');
        console.log(`stderr: ${stderr}`);
        callback(error, null)
      }

      callback(null, true);
    });
  });

  socket.on('hwloc-bind-thread', function ( tid, runner, callback ) {
    exec('../../../utils/hwloc/hwloc-bind --tid ' + tid + ' ' + runner, ( error, stdout, stderr ) => {

      if ( error ) {
        console.log(`error: ${error.message}`);
        socket.emit('hwloc-bind', 'failed');
        callback(error, null);
      }

      if ( stderr ) {
        socket.emit('hwloc-bind', 'failed');
        console.log(`stderr: ${stderr}`);
        callback(error, null)
      }

      callback(null, true);
    });
  });
});

http.listen(HPPORT, () => {
  console.log('listening on *:' + HPPORT);
});

function buildProcessesObject(processesStr) {
  let processesArray = processesStr.split('\n');
  let processesObject = { processes: new Array() };

  for ( let i = 0; i <= processesArray.length; i++ ) {
    
    if ( processesArray[i] && processesArray[i][0] != ' ' ) {
        processArray = processesArray[i].split('\t');
        processObject = { PID: processArray[0], name: processArray[1], object: processArray[3], mpiRank: processArray[4], threads: new Array() };
        processesObject.processes.push(processObject);

    } else if ( processesArray[i] ) {
      threadArray = processesArray[i].split('\t');
      threadObject = { TID: threadArray[0], name: threadArray[1], object: threadArray[3], mpiRank: processesObject.processes[processesObject.processes.length - 1].mpiRank};

      processesObject.processes[processesObject.processes.length - 1].threads.push(threadObject);
    }
  }

  return processesObject;
}
