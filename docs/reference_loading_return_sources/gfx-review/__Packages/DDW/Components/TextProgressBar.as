class DDW.Components.TextProgressBar extends DDW.Components.DefaultProgressBar
{
   var _meter;
   var _progress;
   var _textBox;
   var _total;
   function TextProgressBar(libraryName, mx)
   {
      super(libraryName,mx);
   }
   function get textBox()
   {
      return this._textBox;
   }
   function set textBox(value)
   {
      this._textBox = value;
      this.setBar();
   }
   function setBar()
   {
      super.setBar();
      this._textBox.text = this._progress + "/" + this._total;
      if(this._progress != 0)
      {
         this._textBox.visible = true;
         this._meter.visible = true;
         this._textBox._textField._visible = true;
         this._meter.graphics._visible = true;
      }
   }
}
