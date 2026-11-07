class DDW.Utils.Metrics
{
   var alpha;
   var height;
   var propertyName;
   var scale;
   var value;
   var width;
   var x;
   var y;
   function Metrics(x, y, width, height, alpha, scale, propertyName, value)
   {
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      this.alpha = alpha != null ? alpha : 100;
      this.scale = scale;
      this.propertyName = propertyName;
      this.value = value;
   }
   function toString()
   {
      return "x:" + this.x + " y:" + this.y + " w:" + this.width + " h:" + this.height + " a:" + this.alpha + " scale: " + this.scale + " propertyName:" + this.propertyName + " v:" + this.value;
   }
}
