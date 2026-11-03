package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _macCloseButtonStyle
   {
      
      private static var _embed_css_mac_close_up_png_184594320:Class = _macCloseButtonStyle__embed_css_mac_close_up_png_184594320;
      
      private static var _embed_css_mac_close_down_png_1260569974:Class = _macCloseButtonStyle__embed_css_mac_close_down_png_1260569974;
      
      private static var _embed_css_mac_close_over_png_1495505686:Class = _macCloseButtonStyle__embed_css_mac_close_over_png_1495505686;
      
      public function _macCloseButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".macCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".macCloseButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = _embed_css_mac_close_up_png_184594320;
               this.overSkin = _embed_css_mac_close_over_png_1495505686;
               this.downSkin = _embed_css_mac_close_down_png_1260569974;
            };
         }
      }
   }
}

