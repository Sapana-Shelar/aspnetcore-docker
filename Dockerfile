FROM microsoft/aspnetcore-build:2.0.0  AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/aspnetcore-build:2.0.0  AS build
WORKDIR /src
COPY ["AspNetCoreOnDocker.csproj", ""]
RUN dotnet restore "./AspNetCoreOnDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AspNetCoreOnDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspNetCoreOnDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspNetCoreOnDocker.dll"]