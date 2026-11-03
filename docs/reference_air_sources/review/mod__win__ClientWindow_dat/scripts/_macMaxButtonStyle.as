package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _macMaxButtonStyle
   {
      
      private static var _embed_css_mac_max_down_png_5550550:Class = _macMaxButtonStyle__embed_css_mac_max_down_png_5550550;
      
      private static var _embed_css_mac_max_over_png_1202652090:Class = _macMaxButtonStyle__embed_css_mac_max_over_png_1202652090;
      
      private static var _embed_css_mac_max_dis_png_480296714:Class = _macMaxButtonStyle__embed_css_mac_max_dis_png_480296714;
      
      private static var _embed_css_mac_max_up_png_2077754680:Class = _macMaxButtonStyle__embed_css_mac_max_up_png_2077754680;
      
      public function _macMaxButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".macMaxButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".macMaxButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = _embed_css_mac_max_up_png_2077754680;
               this.overSkin = _embed_css_mac_max_over_png_1202652090;
               this.downSkin = _embed_css_mac_max_down_png_5550550;
               this.disabledSkin = _embed_css_mac_max_dis_png_480296714;
            };
         }
      }
   }
}

