class DDW.Utils.TextMetrics extends DDW.Utils.Metrics
{
   var align;
   var bold;
   var font;
   var fontSize;
   var height;
   var leading;
   var text;
   var textColor;
   var width;
   var x;
   var y;
   function TextMetrics(x, y, width, height, text, align, bold, font, fontSize, leading, textColor)
   {
      super(x,y,width,height);
      this.text = text;
      this.align = align;
      this.bold = bold;
      this.font = font;
      this.fontSize = fontSize;
      this.leading = leading;
      this.textColor = textColor;
   }
   function toString()
   {
      return "(text) x:" + this.x + " y:" + this.y + " w:" + this.width + " h:" + this.height + " ft: " + this.font + "sz: " + this.fontSize + " col: " + this.textColor;
   }
}
