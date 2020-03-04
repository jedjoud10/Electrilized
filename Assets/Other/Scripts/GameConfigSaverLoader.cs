using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
//Loads and saves  a string that contains the game's configuration
public class GameConfigSaverLoader
{
    string config_path;//Path of config file
    //Setup pathes fo config saver loader
    public void SetupPathes()
    {
        config_path = Application.persistentDataPath + "/config.txt";
    }
    //Save the string into config file
    public void SaveConfig(GameConfig gameConfig)
    {
        string content = JsonUtility.ToJson(gameConfig, true);//Transforms the gameConfig to json then string. Then save it
        File.WriteAllText(config_path, content);
    }
    //Load the string from config file
    public GameConfig LoadConfig()
    {
        if (File.Exists(config_path))
        {
            return JsonUtility.FromJson<GameConfig>(File.ReadAllText(config_path));//From string to gameConfig then load
        }
        else
        {
            Debug.LogWarning("Config file does not exist !");
        }
        return null;
    }
}
//Class that holds information about the game configuration
public class GameConfig
{
    #region QualitySettings
    //Rendering    
    public int PixelLightCount;
    public int TextureQuality;
    public string AnisotropicTextures;
    public bool SoftParticles;
    public bool RealtimeReflectionProbes;
    public int ReflectionProbesResolution;
    public int ReflectionProbesRefresh;
    public bool BillboardsFaceCameraPosition;
    public float ResolutionScalingFixedDPI;
    public bool TextureStreaming;
    //Post-processing
    public bool usePostProcessing;
    public bool useColorGrading;
    public bool useChromaticAberration;
    public bool useBloom;
    public bool useVignette;
    public bool useAutoExposure;
    public bool useMotionBlur;
    public bool useAmbientOcclusion;
    public int useAntiAliasing;
    //Shadows
    public string ShadowsType;
    public string ShadowsResolution;
    public float ShadowDistance;
    //Other
    public string SkinWeights;
    public int VSync;
    public float LODBias;
    public int MaxLODLevel;
    #endregion
}
