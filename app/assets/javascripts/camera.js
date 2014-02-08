Camera.prototype = {
  view: function() {
    var imagepath = this.videoUrl;
    var height = 480
    var width = 640

    var output = '<img SRC="' + imagepath + '"width="' + width + '"height="' + height +'" width="' + width;
    output += '" border=0 ALT="If no image is displayed, there might be too many viewers, or the browser configuration may have to be changed. See help for detailed instructions on how to do this." width=' + width + ' height=' + height +' width=' + width + ' class="capture-photo" id="camera_photo">';
    output += '<a href="javascript:camera.snapshot();">Avtryckare</a>';
    output += '<a href="javascript:camera.video();">Ångra</a>';

    return output;
  },

  snapshot: function() {
    var img = document.getElementById('camera_photo');
    var self = this;
    img.onload = function(e) {
      var b64 = self._getBase64Image(img);
      document.getElementById('karnevalist_image_data').value = b64;
    };
    img.crossOrigin = '';
    img.src = this.photoUrl;
  },

  video: function() {
    var img = document.getElementById('camera_photo');
    img.src = this.videoUrl;
  },

  // Code taken from MatthewCrumley
  // http://stackoverflow.com/a/934925/298479
  _getBase64Image: function(img) {
    var canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;

    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0);

    var dataURL = canvas.toDataURL("image/png");

    return dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
  }
};

function Camera(cameraUrl) {
  this.cameraUrl = cameraUrl;

  this.videoUrl = this.cameraUrl + "mjpg/video.mjpg";
  this.photoUrl = this.cameraUrl + "jpg/image.jpg";
}
