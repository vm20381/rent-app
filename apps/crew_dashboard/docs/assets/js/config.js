!function(){var t=sessionStorage.getItem("__TECHUI_CONFIG__"),e=document.getElementsByTagName("html")[0],o={theme:"light",layout:{mode:"detached"},topbar:{color:"light"},sidenav:{size:"default",color:"dark"}};this.html=document.getElementsByTagName("html")[0],(config=Object.assign(JSON.parse(JSON.stringify(o)),{})).theme=e.getAttribute("data-bs-theme")||o.theme,config.layout.mode=e.getAttribute("data-layout-mode")||o.layout.mode,config.topbar.color=e.getAttribute("data-topbar-color")||o.topbar.color,config.sidenav.color=e.getAttribute("data-sidenav-color")||o.sidenav.color,config.sidenav.size=e.getAttribute("data-sidenav-size")||o.sidenav.size,window.defaultConfig=JSON.parse(JSON.stringify(config)),null!==t&&(config=JSON.parse(t)),(window.config=config)&&(e.setAttribute("data-bs-theme",config.theme),e.setAttribute("data-layout-mode",config.layout.mode),e.setAttribute("data-topbar-color",config.topbar.color),e.setAttribute("data-sidenav-color",config.sidenav.color),e.setAttribute("data-sidenav-size",config.sidenav.size)),window.innerWidth<=1040&&e.setAttribute("data-sidenav-size","overlay")}();