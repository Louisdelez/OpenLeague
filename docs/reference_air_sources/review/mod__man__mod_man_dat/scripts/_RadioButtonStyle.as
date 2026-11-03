package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.RadioButtonIcon;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _RadioButtonStyle
   {
      
      public function _RadioButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("RadioButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("RadioButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.icon = RadioButtonIcon;
               this.downSkin = null;
               this.overSkin = null;
               this.selectedDisabledSkin = null;
               this.disabledIcon = null;
               this.upIcon = null;
               this.selectedDownIcon = null;
               this.cornerRadius = 7;
               this.iconColor = 2831164;
               this.selectedUpSkin = null;
               this.overIcon = null;
               this.skin = null;
               this.paddingLeft = 0;
               this.paddingRight = 0;
               this.upSkin = null;
               this.fontWeight = "normal";
               this.selectedDownSkin = null;
               this.selectedUpIcon = null;
               this.selectedOverIcon = null;
               this.selectedDisabledIcon = null;
               this.textAlign = "left";
               this.disabledSkin = null;
               this.horizontalGap = 5;
               this.selectedOverSkin = null;
               this.downIcon = null;
            };
         }
      }
   }
}

