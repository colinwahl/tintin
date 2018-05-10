module Tintin.Html.Templating where

import Lucid

import Tintin.Core
import qualified Tintin.Html.Style as Style


wrapPage :: [RenderedData] -> RenderedData -> Text
wrapPage pages rd = toText . renderText $ do
  tintinHeader $ renderedDataTitle rd
  body_ [class_ "tintin-fg-black tintin-bg-white"] $ do
    section_ [ id_ "content"] $ do
      div_ [id_ "wrapper", class_ "toggled"] $ do
        div_ [id_ "sidebar-wrapper", class_ "h-100 tintin-bg-lightblue"] $ do
          ul_ [ class_ "sidebar-nav"] $ do
            li_ [ class_ "sidebar-brand tintin-bg-blue"] $ do
              a_ [href_ "index.html", class_ "tintin-fg-white"] "Tintin"
            forM (filter (\x -> "index.html" /= renderedDataFile x ) pages ) $ \page -> do
              li_ $ do
                let classes =
                      if renderedDataTitle page == renderedDataTitle rd
                      then "tintin-fg-white"
                      else "tintin-fg-blue"
                a_ [href_ $ renderedDataFile page, class_ classes] $ do
                  ( toHtml $ renderedDataTitle page )

        nav_ [class_ "navbar navbar-expand-lg tintin-fg-white tintin-bg-grey"] $ do
          a_ [id_ "menu-toggle", href_ "#menu-toggle"] $
            img_ [ src_ "https://png.icons8.com/material/49/ffffff/menu.png" ]

        div_ [id_ "page-content-wrapper"] $ do
          div_ [class_ "container"] $ do
            div_ [class_ "col"] $
              toHtmlRaw $ renderedDataContent rd
      tintinPostInit


wrapHome :: [RenderedData] -> RenderedData -> Text
wrapHome pages rd = toText . renderText $ do
  tintinHeader ( renderedDataTitle rd )
  body_ [class_ "tintin-fg-black tintin-bg-white"] $ do
    navbar

    div_ [class_ "cover-container d-flex h-100 p-3 mx-auto flex-column tintin-bg-blue tintin-fg-white"] $ do
      main_ [role_ "main", class_ "masthead mb-auto h-100"] $ do
        div_ [class_ "container h-100"] $ do
          div_ [class_ "row h-100 align-items-center"] $ do
            div_ [class_ "col"] $ do
              h1_ [class_ "cover-heading"] $ toHtml ( renderedDataTitle rd )
              h2_ "Document your package, before asking Haddock"
            div_ [class_ "col"] $ do
              div_ [class_ "d-flex justify-content-center"] $
                pre_ [style_ "font-size: 900%; color: #de935f;"] ")``)"
    section_ [ id_ "content"
             , data_ "aos" "fade-up"
             , data_ "aos-duration" "800"
             , data_ "aos-once" "true"
             ] $ do
      div_ [class_ "container"] $ do
        div_ [class_ "content"
             ] $
          div_ [class_ "rawr"] $ do
            toHtmlRaw $ renderedDataContent rd
    footer
    tintinPostInit
 where
  navbar =
    nav_ [ class_ "navbar navbar-expand-lg navbar-dark tintin-navbar tintin-bg-lightblue position-absolute"
         , style_ "bottom:0; width: 100%;"
         ] $ do
      div_ [class_ "collapse navbar-collapse", id_ "navbarSupportedContent"] $ do
        ul_ [class_ "navbar-nav mr-auto"] $ do
          li_ [class_ "nav-item active"] $
            a_ [class_ "nav-link active", href_ "/index.html"] "Home"
          let (page:_) = filter (\x -> "index.html" /= renderedDataFile x ) pages
          li_ [class_ "nav-item"] $
            a_ [class_ "nav-link", href_ ( renderedDataFile page )] "Docs"
      div_ $
        ul_ [class_ "navbar-nav mr-sm-2"] $
          li_ [class_ "nav-item"] $
            a_ [class_ "nav-link", href_ "https://github.com/theam/tintin"] "View on GitHub"

  footer =
    footer_ [ class_ "tintin-bg-darkgrey tintin-fg-white"] $
      div_ [class_ "container"] $
        div_ [class_ "row"] $ do
          div_ [class_ "col"] $
            p_ [class_ "tintin-fg-lightgrey"] $ do
              "Developed by "
              a_ [href_ "github.com/theam"] "theam"
          div_ [class_ "col"] $
            p_ [class_ "tintin-fg-lightgrey float-right"] $ do
              "Built with "
              a_ [href_ "theam.github.io/tintin"] "tintin"


tintinHeader :: Text -> Html ()
tintinHeader pageTitle =
  head_ $ do
    title_ ( toHtml pageTitle )
    link_ [ rel_ "stylesheet"
          , href_ "https://cdn.rawgit.com/michalsnik/aos/2.1.1/dist/aos.css"
          ]
    link_ [ rel_ "stylesheet"
          , href_ "https://fonts.googleapis.com/css?family=Karla|Montserrat:700"
          ]
    link_ [ rel_ "stylesheet"
          , href_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          ]
    link_ [ rel_ "stylesheet"
          , href_ "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/tomorrow-night.min.css"
          ]
    style_ Style.style

tintinPostInit :: Html ()
tintinPostInit = do
  script_ [ src_ "https://code.jquery.com/jquery-3.2.1.slim.min.js" ] ( "" :: Text )
  script_ [ src_ "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"] ( "" :: Text )
  script_ [ src_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"] ( "" :: Text )
  script_ [ src_ "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"] ( "" :: Text )
  script_ [ src_ "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/languages/haskell.min.js"] ("" :: Text)
  script_ [ src_ "https://cdn.rawgit.com/icons8/bower-webicon/v0.10.7/jquery-webicon.min.js" ] ( "" :: Text )
  script_ "$(function() { AOS.init(); })"
  script_ [ src_ "https://cdn.rawgit.com/michalsnik/aos/2.1.1/dist/aos.js"] ("" :: Text)
  script_ "hljs.initHighlightingOnLoad()"
  script_ "$(function () {$(\"#menu-toggle\").click(function(e) {\
        \e.preventDefault();\
        \$(\"#wrapper\").toggleClass(\"toggled\");\
    \})});"


