#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS http://*:5000
ENV ASPNETCORE_ENVIRONMENT docker


FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["deneme/deneme.csproj", "deneme/"]
RUN dotnet restore "deneme/deneme.csproj"
COPY . .
WORKDIR "/src/deneme"
RUN dotnet build "deneme.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "deneme.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "deneme.dll"]