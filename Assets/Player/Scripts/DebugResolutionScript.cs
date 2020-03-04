using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//Loops over resolutions and sets the current screen resolution to the selected one
public class DebugResolutionScript : MonoBehaviour
{
    private Resolution[] resolutions = { new Resolution(1080, 1920), new Resolution(900, 1600), new Resolution(768, 1366), new Resolution(720, 1280), new Resolution(480, 640) };
    private int currentResolution;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.V)) 
        {
            currentResolution++;
            Resolution current = resolutions[currentResolution % resolutions.Length];
            Screen.SetResolution(current.width, current.height, true);
        }
    }
}
public class Resolution 
{
    public int width;
    public int height;
    public Resolution(int _height, int _width)
    {
        width = _width;
        height = _height;
    }
}

