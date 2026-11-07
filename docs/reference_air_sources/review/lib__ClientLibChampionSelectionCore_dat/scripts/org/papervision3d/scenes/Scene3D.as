package org.papervision3d.scenes
{
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.core.render.BasicRenderEngine;
   import org.papervision3d.core.render.InteractiveRendererEngine;
   
   public class Scene3D extends SceneObject3D
   {
      
      public function Scene3D(container:Sprite, interactive:Boolean = false)
      {
         super(container);
         this.interactive = interactive;
         if(interactive)
         {
            renderer = new InteractiveRendererEngine(this);
            interactiveSceneManager = InteractiveRendererEngine(renderer).interactiveSceneManager;
            interactiveSceneManager.initListeners();
         }
         else
         {
            renderer = new BasicRenderEngine();
         }
      }
      
      override protected function renderObjects(camera:CameraObject3D) : void
      {
         container.graphics.clear();
         this.stats = renderer.render(this,container,camera);
         stats.performance = getTimer() - stats.performance;
      }
   }
}

