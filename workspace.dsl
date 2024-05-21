workspace "Mão na massa CMS" {

    model {
        writer = person "Editor" "Pessoa que escreve conteúdo para o site."
        reader = person "Leitor" "Pessoa que consome as notícias do site."

        cms = softwareSystem "Sistema de gerenciamento de conteúdo" {
            mobile = container "Aplicativo móvel" "Android | iOS" "Permite acesso ao conteúdo e as notícias do portal." "Mobile App"
            portal = container "Portal de notícias" "Python e Django" "Site que fornece as notícias e conteúdos. Possui área acessível somente para editores." "Web Browser"
            db = container "Banco de dados SQL" "AWS RDS/PostgreSQL" "Armazena as informações dos usuários e conteúdo." "Database, Amazon Web Services - RDS"
            storage = container "Armazenamento de imagens" "Armazena imagens que serão utilizadas nas notícias e no conteúdo do portal." "Bucket S3" "Storage, Amazon Web Services - Simple Storage Service"
            queue = container "Fila de processamento em segundo plano" "Recebe eventos de criação de imagem para serem consumidos pelo processador." "AWS SQS" "Amazon Web Services - Simple Queue Service"
            worker = container "Processador de Imagens" "Processa imagens otimizando-as e gerando thumbnails." "Python"
        }

        reader -> portal "Consome notícias e conteúdo em"
        reader -> mobile "Consome notícias e conteúdo em"
        writer -> portal "Escreve conteúdo em"
        mobile -> portal "Consome notícias e conteúdo em" "HTTPS/JSON"
        portal -> db "Lê de e escreve em" "PostgreSQL Protocol"
        portal -> storage "Lê de e escreve em" "HTTPS/JSON"
        worker -> queue "Consome eventos de" "AMQP" "async"
        worker -> storage "Escreve imagens em" "HTTPS/JSON" "async"
        worker -> storage "Escreve imagens em" "HTTPS/JSON" "async"
        worker -> storage "Escreve imagens em" "HTTPS/JSON" "async"
        portal -> queue "Envia evento de adição de nova imagem para" "AMQP" "async"
        portal -> storage "Consome conteúdo estático de" "HTTPS/JSON"
    }

    views {
        systemContext cms "SystemContext" {
            include *
            autoLayout
        }

        container cms "Containers" {
            include *
            autolayout lr
        }

        theme default
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/icons.json

        styles {
            relationship "Relationship" {
                color #C7C7C7
                dashed false
                routing Curved
            }
            relationship "async" {
                color #C7C7C7
                dashed true
            }
            element "Database" {
                shape cylinder
            }
            element "Storage" {
                shape Folder
                height 400
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
            }
            element "Web Browser" {
                shape WebBrowser
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}