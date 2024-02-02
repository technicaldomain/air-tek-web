ARG ASPNET5_IMAGE_VERSION=1.2.0
ARG ECR_REGISTRY=342820895256.dkr.ecr.us-east-1.amazonaws.com
ARG ECR_REPO=air-tek-docker-baseimages/aspnet-5
ARG ASPNET_SDK_IMAGE_VERSION=5.0-focal

FROM mcr.microsoft.com/dotnet/sdk:${ASPNET_SDK_IMAGE_VERSION} AS build
WORKDIR /src
COPY . .
RUN dotnet restore "infra-web.csproj"
RUN dotnet build "infra-web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "infra-web.csproj" -c Release -o /app/publish

FROM ${ECR_REGISTRY}/${ECR_REPO}:${ASPNET5_IMAGE_VERSION} AS final
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "infra-web.dll"]
