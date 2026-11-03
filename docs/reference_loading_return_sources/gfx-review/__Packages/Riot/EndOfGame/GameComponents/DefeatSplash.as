class Riot.EndOfGame.GameComponents.DefeatSplash extends Riot.EndOfGame.GameComponents.SplashScreen
{
   var btDefeatContinue;
   var layoutData;
   var libraryName;
   var txLabel;
   var txLabelB;
   var _class = "DefeatSplash";
   var layoutHash = [["defeatBkg","DisplayObject"],["btDefeatContinue","DefaultButton"],["txLabel","DefaultTextBox"],["txLabelB","DefaultTextBox"]];
   function DefeatSplash(layoutMcName, mx)
   {
      super(null,mx);
      this.layoutData = DDW.Managers.LayoutManager.getLayout(layoutMcName);
   }
   function setCommNames(commMappings)
   {
      this.btDefeatContinue.commName = "Continue";
   }
   function createGraphics()
   {
      super.createGraphics();
      this.txLabel.text = "flash_endOfGame_defeat";
      this.txLabelB.text = "flash_endOfGame_defeat";
      this.btDefeatContinue.graphics.txLabel.text = "flash_endOfGame_continue";
      this.txLabelB._textField.shadowDistance = 0;
      this.txLabelB._textField.shadowColor = 4524811;
      this.txLabelB._textField.shadowBlurX = 3;
      this.txLabelB._textField.shadowBlurY = 3;
      this.txLabelB._textField.shadowStrength = 10;
      this.txLabel._textField.shadowDistance = 6;
      this.txLabel._textField.shadowColor = 0;
      this.txLabel._textField.shadowStrength = 8;
      this.txLabel._textField.shadowBlurX = 3;
      this.txLabel._textField.shadowBlurY = 3;
      this.txLabel._textField.shadowAlpha = 0.5;
      this.txLabel.kerning = true;
      this.txLabel.letterSpacing = 10;
      this.txLabelB.kerning = true;
      this.txLabelB.letterSpacing = 10;
   }
   function toString()
   {
      return this._class + " : " + this.libraryName;
   }
}
