# Execute a sequence of actions
all: warming build linting security unittest cooling

warming-client:
	cd client && npm run setup

warming-infra:
	cd infra && npm run setup

warming-server:
	cd server && mvn -N wrapper:wrapper

# Pipeline sequence
## The warming step pre-warms the environment with:
warming:
	@echo "Start the project building"
	cd server && mvn -N wrapper:wrapper && cd ../client && npm run setup && cd ../infra && npm run setup

build-client:
	npm run build

build-server:
	cd server && ./mvnw clean install && cd target && zip source-bundle.zip server-0.0.1-SNAPSHOT.jar

## This step builds applications and creates deliverable items
build:
	cd server && ./mvnw clean install && cd target && zip source-bundle.zip server-0.0.1-SNAPSHOT.jar && cd ../../client && npm run build && cd ../infra && npm run build
## This step checks the code base with linting tools
linting:
	cd client && npm run eslint
## This step checks the code base with security tools
security:
	cd infra && cfn_nag_scan -i ./cdk.out -t ..\*.template.json
## This step executes unit tests for the code base
unittest:
	cd infra && npm run test

start-client:
	cd ./client && npm run start

start-server:
	java -jar ./server/target/server-0.0.1-SNAPSHOT.jar

start:
	java -jar ./server/target/server-0.0.1-SNAPSHOT.jar && cd ./client && npm run start

## This step cleans up the environment from the secret values
cooling:
	@echo "Finish the project building"

# Manual execution
## Cleanup the whole environment. Remove all temporary files
clean:
	git clean -Xdf
## Deploy application to the AWS account.
deploy:
	cd infra && npm run cdk -- deploy CodePipeline --require-approval never
## Execute integration tests for verification
validate:
	cd infra && chmod +x ./test/test_validate.sh && ./test/test_validate.sh
destroy:
	cd infra && npm run cdk destroy --all

##rm -rf infra/node_modules/ infra/package-lock.json infra/resources/ client/node_modules/ client/package-lock.json .idea/workspace.xml infra/cdk.out/ infra/coverage/