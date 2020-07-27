# Собранные библиотеки V8 готовые для использования в V8JS

Как собрать v8:
1) `docker build -t v8-build .` (Сборка может занимать до часа)
2) Запускаем `docker run --name v8 -d v8-build`
3) Копируем файлы v8 из контейнера для дальнейшего использования 
`
docker cp v8:/usr/local/lib v8/lib 
docker cp v8:/usr/local/include v8/include
`