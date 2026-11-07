class Riot.EndOfGame.GameComponents.VictorySplash extends Riot.EndOfGame.GameComponents.SplashScreen
{
   var btVictoryContinue;
   var layoutData;
   var libraryName;
   var txLabel;
   var txLabelB;
   var _class = "VictorySplash";
   var layoutHash = [["victoryBkg","DisplayObject"],["btVictoryContinue","DefaultButton"],["txLabelB","DefaultTextBox"],["txLabel","DefaultTextBox"]];
   function VictorySplash(layoutMcName, mx)
   {
      super(null,mx);
      this.layoutData = DDW.Managers.LayoutManager.getLayout(layoutMcName);
   }
   function setCommNames(commMappings)
   {
      this.btVictoryContinue.commName = "Continue";
   }
   function createGraphics()
   {
      super.createGraphics();
      this.txLabelB.text = "flash_endOfGame_victory";
      this.txLabel.text = "flash_endOfGame_victory";
      this.btVictoryContinue.graphics.txLabel.text = "flash_endOfGame_continue";
      this.txLabel._textField.shadowDistance = 0;
      this.txLabel._textField.shadowColor = 8606769;
      this.txLabel._textField.shadowBlurX = 3;
      this.txLabel._textField.shadowBlurY = 3;
      this.txLabel._textField.shadowStrength = 10;
      this.txLabelB._textField.shadowDistance = 6;
      this.txLabelB._textField.shadowColor = 0;
      this.txLabelB._textField.shadowStrength = 8;
      this.txLabelB._textField.shadowBlurX = 5;
      this.txLabelB._textField.shadowBlurY = 5;
      this.txLabelB._textField.shadowAlpha = 0.5;
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
