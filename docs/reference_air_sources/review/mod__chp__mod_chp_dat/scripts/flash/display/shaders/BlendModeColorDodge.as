package flash.display.shaders
{
   public class BlendModeColorDodge extends AbstractBlendMode
   {
      
      internal static var PBJ:Class = BlendModeColorDodge_PBJ;
      
      public function BlendModeColorDodge()
      {
         super(new PBJ());
      }
   }
}

