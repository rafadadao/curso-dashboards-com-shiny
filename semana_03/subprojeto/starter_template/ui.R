###############################################################################
# Zetta Health Academy - Curso Dashboards com Shiny
# PROJETO 2 - Caixas interativas e Mapas
###############################################################################
# URL: https://github.com/zetta-academy/curso-dashboards-com-shiny
# Autor: Henrique Gomide, Ph.D.
#
# Esta e a interface grafica do aplicativo Shiny (o que vai aparecer na tela) 
# Para executar a aplicacao: clique em 'Run App' no canto superior direito deste
# quadrante 
#
# Recomendamos que busque mais informacoes sobre o shiny neste link:
#    http://shiny.rstudio.com/

# Você precisará instalar este pacote
# Documentação https://rstudio.github.io/shinydashboard/structure.html 
library(shinydashboard) # Você precisará instalar este pacote

library(shiny)


# Carrega a lista de cidades
city_options <- read_lines("data/city_selector.gz")


#  Definir a interface grafica da aplicacao shiny 
shinyUI <- dashboardPage(
    dashboardHeader(title = "Dashboards com Shiny"),
    dashboardSidebar(
    ),
    dashboardBody(
        fluidRow(
            box(
                title = "Cidade: ",
                selectInput("city",
                            label = "Selecione uma cidade", 
                            choices = city_options,
                            selected = city_options[0]),
            )
        ),
        fluidRow(
            # Exercício 1:
            # Melhoria de Interface do Usuário
            # Insira a data da última observação válida como cabeçalho (h1)
            # Seu código aqui:
            h1("Data última observação:"),
            h1(format(as.Date(unique(max(covid19$date))),"%d/%m/%Y")),
      
            
            # Fim do exercício 1
            infoBoxOutput("numeroCasosAcumulados"),
            infoBoxOutput("numeroCasosUltimoDia"),
            valueBoxOutput("numeroReproEfetivo")
            
        ),
        fluidRow(
            # Exercício 2:
            # Adicione o mapa feito na primeira parte da aula. 
            # Especificações:
            # 1. O mapa deve estar centralizado na cidade escolhida pelo selectInput
            # 2. O mapa deve conter indicadores sobre COVID usando marcadores e 
            #    polígonos que separam as cidades
            # 3. Seu código abaixo:
            
            m <- 
                leaflet(shapefile) %>% 
                addProviderTiles(providers$Stamen.TonerLite) %>% 
                setView(lng = cidade_sp_geo$longitude,
                        lat = cidade_sp_geo$latitude, 
                        zoom = 11) %>% 
                addPolygons(stroke = FALSE,
                            smoothFactor = .5,
                            fillOpacity = .4,
                            fillColor = ~pal(log(new_confirmed + 1e-3)),
                            label = ~paste0(name, 
                                            ": ",
                                            formatC(new_confirmed,
                                                    big.mark = ","))) %>% 
                addAwesomeMarkers(~longitude, 
                                  ~latitude, 
                                  icon = makeAwesomeIcon(icon = "",
                                                         text = "", 
                                                         markerColor = "cadetblue"),
                                  popup = 
                                      sprintf("<h3>%s</h3>
                                   <p>Última atualização: %s</p>
                                   <p><b>Últimas 24h:</b></h5>
                                   <p>Casos<b>: %0.f</b></p>
                                   <p>Mortes<b>: %0.f</b></p>
                                   ", 
                                              shapefile@data$nome,
                                              format.Date(shapefile@data$date, "%d/%m/%Y"),
                                              shapefile@data$new_confirmed,
                                              shapefile@data$new_deaths
                                      ),
                                  clusterOptions = markerClusterOptions()
                )
            
            
            # Fim do exercício 2
        ),
        fluidRow(
            # Desafio (Difícil):
            # Adicione um gráfico de linhas com variações do R efetivo ao longo
            # do tempo para o município.
            # Seu código abaixo:
            
            
            # Fim do desafio
        )
    )
)
